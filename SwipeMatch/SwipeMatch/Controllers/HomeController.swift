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
            User(name: "Jane", age: 21, profession: "Whore", imageNames: ["jane3", "jane1", "jane2"]),
            User(name: "Kelly", age: 22, profession: "Whoore", imageNames: ["kelly1", "kelly2", "kelly3"]),
            User(name: "Ladyc", age: 23, profession: "Whooore", imageNames: ["lady4c", "lady5c"]),
            Advertiser(title: "Promt", brandName: "PromtHub", posterPhotoName: "slide_out_menu_poster")
            
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map { return $0.toCardViewModel()}
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupDummyCards()
    }
    
    @objc func handleSettings() {
        print("peee pee poopoo")
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    
    // MARK:- Fileprivate
    
    fileprivate func setupDummyCards(){
        cardViewModels.forEach { (cvm) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cvm
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

