//
//  MainViewController.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MainDefaultColors.background.getUIColor()
        
        let layoutFrameSafeArea = self.view.safeAreaLayoutGuide.layoutFrame
        let safeAreaInsets = self.view.safeAreaInsets
        
        let verticalView = createVerticalView(frame: CGRect())
//        let verticalView = createVerticalView(frame: CGRect(
//            x: safeAreaInsets.left,
//            y: safeAreaInsets.bottom,
//            width: layoutFrameSafeArea.size.width,
//            height: layoutFrameSafeArea.size.width
//        ))

        view.addSubview(verticalView)
        
        NSLayoutConstraint.activate([
            verticalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
//        let horizontalView = createHorizontalView(frame: CGRect(x: 5, y: 0, width: verticalView.frame.width - 10, height: 150))
        let horizontalView = createHorizontalView(frame: CGRect())
        verticalView.addSubview(horizontalView)

        NSLayoutConstraint.activate([
            horizontalView.topAnchor.constraint(equalTo: verticalView.topAnchor),
            horizontalView.leadingAnchor.constraint(equalTo: verticalView.leadingAnchor, constant: 5),
            horizontalView.trailingAnchor.constraint(equalTo: verticalView.trailingAnchor, constant: 5),
            horizontalView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let coinIncomeTile = CoinIncomeTile()
//        coinIncomeTile.frame = CGRect(x: 0, y: 0, width: (horizontalView.frame.width - 50) / 2, height: horizontalView.frame.height)
        coinIncomeTile.setup(titleText: "Траты")
        coinIncomeTile.translatesAutoresizingMaskIntoConstraints = false
        horizontalView.addSubview(coinIncomeTile)

        NSLayoutConstraint.activate([
            coinIncomeTile.topAnchor.constraint(equalTo: horizontalView.topAnchor),
            coinIncomeTile.bottomAnchor.constraint(equalTo: horizontalView.bottomAnchor),
            coinIncomeTile.leadingAnchor.constraint(equalTo: horizontalView.leadingAnchor),
            coinIncomeTile.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: coinIncomeTile, action: #selector(coinIncomeTile.longPress))
        longPressGestureRecognizer.minimumPressDuration = 1
        coinIncomeTile.addGestureRecognizer(longPressGestureRecognizer)
                
        print("DEBUG: displayed main view")
    }
    
    private func createVerticalView(frame: CGRect) -> UIStackView {
        
//        let verticalView = UIStackView(frame: frame)
        let verticalView = UIStackView()
        
        verticalView.axis = .vertical
        verticalView.alignment = .center
        verticalView.distribution = .fill
        verticalView.spacing = 5
        verticalView.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalView
    }
    
    private func createHorizontalView(frame: CGRect) -> UIStackView {
        
//        let horizontalView = UIStackView(frame: frame)
        let horizontalView = UIStackView()
        horizontalView.axis = .horizontal
        horizontalView.distribution = .equalSpacing
        horizontalView.spacing = 5
        horizontalView.translatesAutoresizingMaskIntoConstraints = false

        return horizontalView
    }
}

fileprivate extension CoinIncomeTile {
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            compressSize()
        case .ended:
            identitySize()
        default:
            return
        }
    }
    
    func compressSize() {
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) })
    }
    
    func identitySize() {
        UIView.animate(withDuration: 0.1, animations: { self.transform = CGAffineTransform.identity })
    }
}
