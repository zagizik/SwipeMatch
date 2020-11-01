//
//  ViewController.swift
//  SwipeMatch
//
//  Created by Александр Банников on 25.10.2020.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let bottomControls = HomeBottomControlsStackView()
    let cardsDeckView = UIView()
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }
    
    @objc func handleSettings() {
        print("peee pee poopoo")
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    
    // MARK:- UI set up

    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView( arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
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
    // MARK:- buttons targets
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    
    //MARK:-  Data fetching
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "FetchinUser"
        hud.show(in: view)
        // pagination on 2 user on time iinstead of all users
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
//            .whereField("age", isLessThan: 28).whereField("age", isGreaterThan: 19)
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to Fetch users:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
//            self.setupFirestoreUserCards()
        }
    }

    fileprivate func setupCardFromUser(user: User){
        cardViewModels.forEach { (cvm) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = user.toCardViewModel()
            cardsDeckView.addSubview(cardView)
            cardsDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupFirestoreUserCards(){
        cardViewModels.forEach { (cvm) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cvm
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

