//
//  MatchesNavBar.swift
//  SwipeMatch
//
//  Created by Александр Банников on 05.12.2020.
//

import UIKit

class MatchesMassagesNavBar: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        shadowSetup()
        addSubview(iconImageView)
        addSubview(messageLabel)
        addSubview(feedLabel)
        
        let hstack = UIStackView(arrangedSubviews: [messageLabel, feedLabel])
        hstack.distribution = .fillEqually
        addSubview(hstack)
        hstack.fillSuperview()
        
        let vstack = UIStackView(arrangedSubviews: [iconImageView, hstack])
        vstack.distribution = .fillEqually
        vstack.axis = .vertical
        addSubview(vstack)
        vstack.fillSuperview()
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))
    }
    
    //MARK:- Layout setup
    
    fileprivate func shadowSetup() {
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.init(white: 0, alpha: 0.3).cgColor
    }
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        return button
    }()
    let iconImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate))
        iv.tintColor = #colorLiteral(red: 0.979567945, green: 0.4075169265, blue: 0.4402788579, alpha: 1)
        iv.contentMode = .center
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return iv
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Message"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 0.979567945, green: 0.4075169265, blue: 0.4402788579, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    let feedLabel: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    //MARK: -
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
