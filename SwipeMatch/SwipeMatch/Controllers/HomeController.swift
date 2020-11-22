//
//  ViewController.swift
//  SwipeMatch
//
//  Created by Александр Банников on 25.10.2020.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    var cardViewModels = [CardViewModel]()
    var topCardView: CardView?
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMassege), for: .touchUpInside)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.dislikebutton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        bottomControls.superLikeButton.addTarget(self, action: #selector(handleSuperLike), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.specialButton.addTarget(self, action: #selector(handleSpecialButton), for: .touchUpInside)
        
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            let navController = UINavigationController(rootViewController: registrationController)
            if #available(iOS 13.0, *) {
                navController.isModalInPresentation = true
            }

            present(navController, animated: true)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    func didSaveSettings() {
        print("notified from dissmisal home controller")
        fetchCurrentUser()
    }
    
    func didTappedMoreInfo(_ cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        print("homecontroller:", cardViewModel.attributedString)
        userDetailsController.modalPresentationStyle = .fullScreen
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true, completion: nil)
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
        
        guard let  dicionary = snapshot?.data() else { return }
        self.user = User(dictionary: dicionary)
            self.fetchUsersFromFirestore()
        }
    }
    
    // MARK:- UI set up

    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.75
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    // MARK:- buttons targets
    
    @objc fileprivate func handleMassege() {
        let messageController = RegistrationController()
        present(messageController, animated: true)
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    
    @objc fileprivate func handleDislike() {
        print("Dislike Tapped")
        performSwipeAnimation(translation: -800, angle: -15)

    }
    
    @objc fileprivate func handleSuperLike() {
        print("SuperLike Tapped")
    }
    
    @objc fileprivate func handleLike() {
        print("Like Tapped")
        performSwipeAnimation(translation: 800, angle: 15)
    }
    
    @objc fileprivate func handleSpecialButton() {
        print("SpecialButton Tapped")
    }
    
    //MARK:-  Data fetching
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }

    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
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

