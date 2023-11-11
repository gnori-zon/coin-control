//
//  UIStackCreatorProtocol.swift
//  coin control
//
//  Created by Stepan Konashenko on 24.10.2023.
//

import UIKit

public protocol UIStackCreatorProtocol {
    
    func createVerticalUIStackView<T: UIView>(in superContainer: T) -> UIStackView
    func createHorizontalUIStackView<T: UIView>(in superContainer: T) -> UIStackView
}

public extension UIStackCreatorProtocol {
    
    func createVerticalUIStackView<T: UIView>(in superContainer: T) -> UIStackView {
        return createUIStackView(in: superContainer, axis: .vertical)
    }
    
    func createHorizontalUIStackView<T: UIView>(in superContainer: T) -> UIStackView {
        return createUIStackView(in: superContainer, axis: .horizontal)
    }
    
    private func createUIStackView<T: UIView>(in superContainer: T, axis: NSLayoutConstraint.Axis) -> UIStackView {
        
        let viewStack = UIStackView()
        
        viewStack.axis = axis
        viewStack.alignment = .leading
        viewStack.distribution = .fillProportionally
        
        viewStack.translatesAutoresizingMaskIntoConstraints = false
        superContainer.addSubview(viewStack)
        
        if axis == .horizontal {
            
            NSLayoutConstraint.activate([
                viewStack.leadingAnchor.constraint(equalTo: superContainer.leadingAnchor),
                viewStack.trailingAnchor.constraint(equalTo: superContainer.trailingAnchor)
            ])
        } else if axis == .vertical{
            
            NSLayoutConstraint.activate([
                viewStack.topAnchor.constraint(equalTo: superContainer.topAnchor, constant: 35),
                viewStack.bottomAnchor.constraint(equalTo: superContainer.bottomAnchor, constant: -10),
                viewStack.leadingAnchor.constraint(equalTo: superContainer.leadingAnchor, constant: 10),
                viewStack.trailingAnchor.constraint(equalTo: superContainer.trailingAnchor, constant: -10)
            ])
        }
        
        return viewStack
    }
}
