//
//  ViewController.swift
//  SwipeMatch
//
//  Created by Александр Банников on 25.10.2020.
//

import UIKit

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let buttonsStackView = HomeBottomControlsStackView()
    let cardsDeckView = UIView()
    let users = [
        User(name: "Ladyone", age: 21, profession: "Whore", imageName: "jane1"),
        User(name: "Ladytwo", age: 22, profession: "Whoore", imageName: "kelly1"),
        User(name: "Ladythree", age: 23, profession: "Whooore", imageName: "lady5c")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards(){
        users.forEach { (user) in
            let cardView = CardView(frame: .zero)
            let attributedString = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
            attributedString.append(NSMutableAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .regular)]))
            attributedString.append(NSMutableAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
            cardView.imageView.image = UIImage(named: user.imageName)
            cardView.informationLabel.attributedText = attributedString
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    // MARK:- Fileprivate

    fileprivate func setupLayout() {
        let overallStackView = UIStackView( arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.safeAreaLayoutGuide.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}

