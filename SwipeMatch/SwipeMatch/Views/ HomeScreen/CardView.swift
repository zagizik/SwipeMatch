//
//  CardView.swift
//  SwipeMatch
//
//  Created by Александр Банников on 25.10.2020.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTappedMoreInfo(_ cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    var nextCardView: CardView?
//    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "photo_placeholder"))
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    var cardViewModel: CardViewModel! {
        didSet {
//            let imageName = cardViewModel.imageUrls.first ?? ""
//            if let url = URL(string: imageName) {
//                imageView.sd_setImage(with: url)
//                imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder"), options: .continueInBackground)
//            }
            swipingPhotosController.cardViewModel = self.cardViewModel
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self ](indx, imageUrl) in
//            let url = URL(string: imageUrl ?? "")
//            self?.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder"), options: .continueInBackground)
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColor
            })
            self?.barsStackView.arrangedSubviews[indx].backgroundColor = .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Gesture recognition
    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto{
            cardViewModel.goToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {

        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChangedCase(gesture)
        case .ended:
            handleEndedCase(gesture)
        default:
            ()
        }
        
    }
    
    fileprivate func handleChangedCase(_ gesture: UIPanGestureRecognizer) {
        
        //radians to degree
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTappedMoreInfo(self.cardViewModel)
    }
    
    fileprivate let threshold: CGFloat = 100
    
    fileprivate func handleEndedCase(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        // hack solution you need to crate and use functions in protocols! view shouldn't do anything but UI! 
        if shouldDismissCard {
            guard let homeController = self.delegate as? HomeController else { return }
            if translationDirection == 1 {
                homeController.handleLike()
            } else {
                homeController.handleDislike()
            }
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
                self.transform = .identity
            }
        }
        
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseOut) {
//
//            if shouldDismissCard {
//              //  self.frame = CGRect(x: 1000 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
//                let offScreenTransorm = self.transform.translatedBy(x: 700 * translationDirection, y: 0)
//                self.transform = offScreenTransorm
//            } else {
//                self.transform = .identity
//            }
//        } completion: { (_) in
//            self.transform = .identity
//            if shouldDismissCard {
//                self.removeFromSuperview()
//                self.delegate?.didRemoveCard(cardView: self)
//            }
//        }
    }

    //MARK: - Layout Setup
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        backgroundColor = .darkGray
        clipsToBounds = true
        let swipingPhotosView = swipingPhotosController.view!
        swipingPhotosView.contentMode = .scaleAspectFill
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        setupGradientLayer()
//        setupBarsStackView()
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 33, right: 22), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.05]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "33").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    fileprivate let barsStackView = UIStackView()
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             bottom: nil,
                             trailing: trailingAnchor,
                             padding: .init(top: 8, left: 8, bottom: 0, right: 8),
                             size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
            // setting fake bars
    }
    
    //MARK: -
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
