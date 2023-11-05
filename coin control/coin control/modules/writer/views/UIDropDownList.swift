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
    
    private let reusableId: String
    private var textColor: UIColor
    private var changeSelectedItemButton: UIButton
    private var dropDownTableView: UITableView
    private var isTableVisible = false
    private var items: [T]
    private var labelGenerator: (T) -> String
    private var selectedItem: T?
   
    private var heightConstraint: NSLayoutConstraint? {
        self.dropDownTableView.constraints.first { $0.firstAttribute == .height}
    }
    
    init(
        reusableId: String,
        labelGenerator: @escaping (T) -> String,
        items: [T],
        textColor: UIColor
    ) {
        
        self.items = items
        self.textColor = textColor
        self.reusableId = reusableId
        self.labelGenerator = labelGenerator
        changeSelectedItemButton = UIButton()
        dropDownTableView = UITableView()
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reusableId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reusableId)
        }
        
        cell?.textLabel?.text = labelGenerator(items[indexPath.row])
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = textColor
        cell?.layer.cornerRadius = cellCornerRadius
        cell?.backgroundColor = TileDefaultColors.background.getUIColor()
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        swapSelectedValue(on: indexPath.row)
        self.heightConstraint?.constant = 0
        self.isTableVisible = false
        self.layoutIfNeeded()
        self.dropDownTableView.reloadData()
    }
    
    private func displayChangeSelectedButton() {
        
        if items.count > 0 {
            
            selectedItem = self.items.removeFirst()
            changeSelectedItemButton.setTitle(labelGenerator(selectedItem!), for: .normal)
            changeSelectedItemButton.setTitleColor(self.textColor, for: .normal)
        }
        
        changeSelectedItemButton.layer.cornerRadius = cellCornerRadius
        changeSelectedItemButton.backgroundColor = TileDefaultColors.background.getUIColor()
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
        
        UIView.animate(withDuration: durationAnimation) {
            
            if self.isTableVisible {
                self.heightConstraint?.constant = 0
            } else {
                self.heightConstraint?.constant = self.cellHeight * CGFloat(self.items.count)
            }
            
            self.isTableVisible = !self.isTableVisible
            self.layoutIfNeeded()
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
