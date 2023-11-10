//
//  CoinActionWriterView.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

public protocol CoinActionWriterViewProtocol {
    func setup(title titleText: String, confirmButtonTitle: String, currencyValues: [CurrencyType], actionValues: [CoinActionType])
}

public final class CoinActionWriterView: UIView, CoinActionWriterViewProtocol {
    
    public var valueValidator: ((UITextField, NSRange, String) -> Bool)?
    public var confirmHandler: ((CoinActionType, String, CurrencyType) -> Void)?
    
    private var titleLabel: UILabel
    private var coinValueField: UITextField
    private var currencyTypeDropDown: UIDropDownList<CurrencyType>!
    private var coinActionTypeDropDown: UIDropDownList<CoinActionType>!
    private var confirmButton: UIButton
    
    init() {
        titleLabel = UILabel()
        coinValueField = UITextField()
        confirmButton = UIButton()
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(
        title titleText: String,
        confirmButtonTitle: String,
        currencyValues: [CurrencyType],
        actionValues: [CoinActionType]
    ) {
        
        backgroundColor = BottomSheetDefaultColors.background.getUIColor()
        
        displayTitle(text: titleText)
        displayCoinActionTypeDropDown(actionValues: actionValues)
        displayCurrencyTypeDropDown(currencyValues: currencyValues)
        displayCoinValueField()
        displayConfirmButton(with: confirmButtonTitle)
    }
    
    private func displayTitle(text: String) {
        
        titleLabel.text = text
        titleLabel.textColor = BottomSheetDefaultColors.titleText.getUIColor()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func displayCoinActionTypeDropDown(actionValues: [CoinActionType]) {
        
        coinActionTypeDropDown = UIDropDownList<CoinActionType>(
            reusableId: "actionTypeCell",
            labelGenerator: { $0.rawStr },
            items: actionValues,
            textColor: BottomSheetDefaultColors.text.getUIColor()
        )
        
        coinActionTypeDropDown.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coinActionTypeDropDown)
        
        NSLayoutConstraint.activate([
            coinActionTypeDropDown.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            coinActionTypeDropDown.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            coinActionTypeDropDown.widthAnchor.constraint(equalToConstant: 110),
            coinActionTypeDropDown.heightAnchor.constraint(equalToConstant: 300)
        ])
        coinActionTypeDropDown.setup()
    }
    
    private func displayCurrencyTypeDropDown(currencyValues: [CurrencyType]) {
        
        currencyTypeDropDown = UIDropDownList<CurrencyType>(
            reusableId: "currencyTypeCell",
            labelGenerator: { $0.currencyRaw.str },
            items: currencyValues,
            textColor: BottomSheetDefaultColors.text.getUIColor()
        )
        
        currencyTypeDropDown.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currencyTypeDropDown)
        
        NSLayoutConstraint.activate([
            currencyTypeDropDown.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            currencyTypeDropDown.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            currencyTypeDropDown.widthAnchor.constraint(equalToConstant: 110),
            currencyTypeDropDown.heightAnchor.constraint(equalToConstant: 300)
        ])
        currencyTypeDropDown.setup()
    }
    
    private func displayCoinValueField() {
        
        coinValueField.backgroundColor = BottomSheetDefaultColors.fieldBackground.getUIColor()
        coinValueField.textColor = BottomSheetDefaultColors.text.getUIColor()
        coinValueField.keyboardType = .decimalPad
        coinValueField.borderStyle = .roundedRect
        coinValueField.textAlignment = .center
        coinValueField.contentVerticalAlignment = .center
        coinValueField.delegate = self
        coinValueField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coinValueField)
        
        NSLayoutConstraint.activate([
            coinValueField.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            coinValueField.leadingAnchor.constraint(equalTo: coinActionTypeDropDown.trailingAnchor, constant: 15),
            coinValueField.trailingAnchor.constraint(equalTo: currencyTypeDropDown.leadingAnchor, constant: -15),
            coinValueField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let hideKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        hideKeyboardRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(hideKeyboardRecognizer)
    }
    
    private func displayConfirmButton(with title: String) {
        
        confirmButton.setTitle(title, for: .normal)
        confirmButton.setTitleColor(BottomSheetDefaultColors.buttonText.getUIColor(), for: .normal)
        confirmButton.layer.cornerRadius = 5
        confirmButton.backgroundColor = BottomSheetDefaultColors.buttonBackground.getUIColor()
        confirmButton.addTarget(self, action: #selector(afterClickConfirm), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: coinValueField.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: coinValueField.centerXAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: coinValueField.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: coinValueField.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalTo: coinValueField.heightAnchor)
        ])
    }
    
    @objc private func afterClickConfirm() {
        
        if let coinValue = coinValueField.text, !coinValue.isEmpty,
           let selectedActionType = self.coinActionTypeDropDown.getSelectedItem(),
           let selectedCurrencyType = self.currencyTypeDropDown.getSelectedItem()
        {
            coinValueField.text = ""
            guard let handler = self.confirmHandler else {
                return
            }
            handler(selectedActionType, coinValue, selectedCurrencyType)
        } else {
            self.snake(coinValueField)
        }
    }
}

// MARK: - UITextFieldDelegate

extension CoinActionWriterView: UITextFieldDelegate {
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        guard let valueValidator else {
            return true
        }
        
        return valueValidator(textField, range, string)
    }
    
    @objc private func hideKeyboard() {
        coinValueField.endEditing(true)
    }
}

// MARK: - DefaultAnimationsProtocol
extension CoinActionWriterView: DefaultAnimationsProtocol {}
