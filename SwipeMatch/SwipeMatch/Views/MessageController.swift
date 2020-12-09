//
//  MessageController.swift
//  SwipeMatch
//
//  Created by Александр Банников on 03.12.2020.
//

import UIKit

class MessageController: UICollectionViewController {
    
    let customNavBar = MatchesMassagesNavBar()



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.backgroundColor = .white
        
//        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        customNavBar.backButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    @objc fileprivate func handleTap() {
        print("tap")
        navigationController?.popToRootViewController(animated: true)
        
    }
}
