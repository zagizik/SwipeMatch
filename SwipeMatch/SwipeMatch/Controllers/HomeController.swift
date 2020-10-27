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
    
    let cardViewModels: [CardViewModel] = { 
        let producers = [
            Advertiser(title: "Promt", brandName: "PromtHub", posterPhotoName: "slide_out_menu_poster"),
            User(name: "Ladyone", age: 21, profession: "Whore", imageName: "jane1"),
            User(name: "Ladytwo", age: 22, profession: "Whoore", imageName: "kelly1"),
            User(name: "Ladythree", age: 23, profession: "Whooore", imageName: "lady5c"),
            Advertiser(title: "Promt", brandName: "PromtHub", posterPhotoName: "slide_out_menu_poster")
            
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map { return $0.toCardViewModel()}
        return viewModels
    }()

//    let cardViewModels = ([
//        Advertiser(title: "Promt", brandName: "PromtHub", posterPhotoName: "slide_out_menu_poster"),
//        User(name: "Ladyone", age: 21, profession: "Whore", imageName: "jane1"),
//        User(name: "Ladytwo", age: 22, profession: "Whoore", imageName: "kelly1"),
//        User(name: "Ladythree", age: 23, profession: "Whooore", imageName: "lady5c"),
//        Advertiser(title: "Promt", brandName: "PromtHub", posterPhotoName: "slide_out_menu_poster")
//    ] as [ProducesCardViewModel]).map { (producer) -> CardViewModel in
//        return producer.toCardViewModel()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupDummyCards(){
        cardViewModels.forEach { (cvm) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cvm
            
//            cardView.imageView.image = UIImage(named: cvm.imageName)
//            cardView.informationLabel.attributedText = cvm.attributedString
//            cardView.informationLabel.textAlignment = cvm.textAligment
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
}

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

