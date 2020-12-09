//
//  UserDetailsController.swift
//  SwipeMatch
//
//  Created by Александр Банников on 06.11.2020.
//

import UIKit
import SDWebImage

protocol UserDetailsControllerDelegate: class {
    func didTapDislike()
    func didTapLike()
    func didTapSuperlike()
}

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            
            swipingPhotosController.cardViewModel = cardViewModel
//            guard let firstImage = cardViewModel.imageUrls.first, let url = URL(string: firstImage) else { return }
//            imageView.sd_setImage(with: url)
        }
    }
    
    var delegate: UserDetailsControllerDelegate?
    
//    let homeController = HomeController()
    
    lazy var scrollview: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
//    let imageView: UIImageView = {
//        let iv = UIImageView(image: #imageLiteral(resourceName: "jane2"))
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        return iv
//    }()
    let swipingPhotosController = SwipingPhotosController()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.text = "User name  30\nDoctor\nBIO"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDissmis), for: .touchUpInside)
        return button
    }()
    
    lazy var  dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var  superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleSuperLike))
    lazy var  likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleLike))
    
    @objc fileprivate func handleDislike() {
        print("dont like")
        dismiss(animated: true) {
            self.delegate?.didTapDislike()
        }
    }
    
    @objc fileprivate func handleSuperLike() {
        print("very like")
        self.dismiss(animated: true, completion: {
            print("Dismissal complete")
            self.delegate?.didTapSuperlike()
        })
    }
    
    @objc fileprivate func handleLike() {
        print("kinda like")
        dismiss(animated: true) {
            self.delegate?.didTapLike()
        }
    }
    
    fileprivate func createButton (image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    fileprivate let extraSwipingHeight: CGFloat = 80
    

    fileprivate func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(scrollview)
        scrollview.fillSuperview()
        
        let swipingView = swipingPhotosController.view!
        scrollview.addSubview(swipingView)
        
        scrollview.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollview.leadingAnchor, bottom: nil, trailing: scrollview.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        scrollview.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 24), size: .init(width: 50, height: 50))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingView = swipingPhotosController.view!
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
        scrollview.addSubview(infoLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupVisualBlur()
        setupBottomControls()
    }
    
    
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.spacing = -32
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupVisualBlur() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY
        width = max(view.frame.width, width)
        let imageView = swipingPhotosController.view!

        imageView.frame = CGRect(x: min(0, -changeY / 2) , y: min(0, -changeY), width: width, height: width + extraSwipingHeight)
    }
    
    @objc fileprivate func handleTapDissmis() {
        self.dismiss(animated: true)
    }
}
