//
//  HomeBottomControlsStackView.swift
//  SwipeMatch
//
//  Created by Александр Банников on 25.10.2020.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let dislikebutton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "boost_circle"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        [refreshButton, dislikebutton, superLikeButton, likeButton, specialButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
