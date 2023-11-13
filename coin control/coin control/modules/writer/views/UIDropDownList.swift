//
//  UIDropDownList.swift
//  coin control
//
//  Created by Stepan Konashenko on 29.10.2023.
//

import UIKit

public final class UIDropDownList<T>: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let cellHeight: CGFloat = 44
    private let cellCornerRadius: CGFloat = 5
    private let durationAnimation: TimeInterval = 0.3
    private let cellBackgroundColor = TileDefaultColors.background.getUIColor()
    
    private let reusableId: String
    private var dropDownTableView = UITableView()
    private var textColor: UIColor
    private var labelGenerator: (T) -> String
    private var isTableVisible = false
    private var items: [T]
    private var selectedItem: T?
    private var changeSelectedItemButton = UIButton()
   
    private var heightConstraint: NSLayoutConstraint? {
        dropDownTableView.constraints.first { $0.firstAttribute == .height}
    }
    
    init(
        reusableId: String,
        labelGenerator: @escaping (T) -> String,
        items: [T],
        textColor: UIColor
    ) {
        
        self.reusableId = reusableId
        self.labelGenerator = labelGenerator
        self.items = items
        self.textColor = textColor
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        
        displayChangeSelectedButton()
        displayDropDownTable()
    }
    
    public func getSelectedItem() -> T? {
        selectedItem
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reusableId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reusableId)
        }
        
        cell?.backgroundColor = cellBackgroundColor
        cell?.layer.cornerRadius = cellCornerRadius
        cell?.textLabel?.text = labelGenerator(items[indexPath.row])
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = textColor
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        swapSelectedValue(on: indexPath.row)
        heightConstraint?.constant = 0
        isTableVisible = false
        layoutIfNeeded()
        dropDownTableView.reloadData()
    }
    
    // MARK: - self private methods
    
    private func displayChangeSelectedButton() {
        
        if items.count > 0 {
            
            selectedItem = items.removeFirst()
            changeSelectedItemButton.setTitle(labelGenerator(selectedItem!), for: .normal)
            changeSelectedItemButton.setTitleColor(textColor, for: .normal)
        }
        
        changeSelectedItemButton.layer.cornerRadius = cellCornerRadius
        changeSelectedItemButton.backgroundColor = cellBackgroundColor
        changeSelectedItemButton.addTarget(self, action: #selector(changeSelectedItem), for: .touchUpInside)
        changeSelectedItemButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(changeSelectedItemButton)
        
        NSLayoutConstraint.activate([
            changeSelectedItemButton.topAnchor.constraint(equalTo: topAnchor),
            changeSelectedItemButton.heightAnchor.constraint(equalToConstant: cellHeight),
            changeSelectedItemButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            changeSelectedItemButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    private func displayDropDownTable() {
        
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.backgroundColor = UIColor.clear
        dropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dropDownTableView)

        NSLayoutConstraint.activate([
            dropDownTableView.topAnchor.constraint(equalTo: changeSelectedItemButton.bottomAnchor, constant: 0.3),
            dropDownTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dropDownTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dropDownTableView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    @objc private func changeSelectedItem() {
        
        UIView.animate(withDuration: durationAnimation) { [unowned self] in
            
            heightConstraint?.constant = isTableVisible
                ? 0
                : cellHeight * CGFloat(items.count)
            
            isTableVisible = !isTableVisible
            layoutIfNeeded()
        }
    }
    
    private func swapSelectedValue(on index: Int) {
        
        let oldValue = selectedItem!
        selectedItem = items.remove(at: index)
        items.append(oldValue)
        
        let newButtonTitle = labelGenerator(selectedItem!)
        changeSelectedItemButton.setTitle(newButtonTitle, for: .normal)
    }
}
