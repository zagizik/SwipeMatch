//
//  MatchView.swift
//  SwipeMatch
//
//  Created by Александр Банников on 22.11.2020.
//

import UIKit
import Firebase


class MatchView: UIView {
    
    var currentUser: User! {
        didSet{
//            guard let url = URL(string: currentUser.imageUrl1 ?? "") else { return }
//            currentUserImageView.sd_setImage(with: url)
        }
    }
    
    // you're almost always guaranteed to have this variable set up
    var cardUID: String! {
        didSet {
            // either fetch current user inside here or pass in our current user if we have it
            
            // fetch the cardUID information
            let query = Firestore.firestore().collection("users")
            query.document(cardUID).getDocument { (snapshot, err) in
                if let err = err {
                    print("Failed to fetch card user:", err)
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                let user = User(dictionary: dictionary)
                guard let url = URL(string: user.imageUrl1 ?? "") else { return }
     
                self.cardUserImageView.sd_setImage(with: url)
                
                guard let currentUserImageUrl = URL(string: self.currentUser.imageUrl1 ?? "") else { return }
                print(currentUserImageUrl)
                self.currentUserImageView.sd_setImage(with: currentUserImageUrl, completed: { (_, _, _, _) in
                    self.setupAnimations()
                })
                
                // setup the description label text correctly somewhere inside of here
                self.descriptionLabel.text = "You and \(user.name ?? "") have liked\neach other."
            }
            
        }
    }
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
        return imageView
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    fileprivate let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override init(frame: CGRect){
        super.init(frame: frame)
        setupBlurView()
        setupLayout()
//        self.setupAnimations()
    }
    
    lazy var views = [
        itsAMatchImageView,
        descriptionLabel,
        currentUserImageView,
        cardUserImageView,
        sendMessageButton,
        self.keepSwipingButton,
    ]
    
    fileprivate func setupLayout() {
        let imageSize: CGFloat = 140
        views.forEach { (v) in
            addSubview(v)
            v.alpha = 0
        }

        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))

        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16) , size: .init(width: imageSize, height: imageSize))
        currentUserImageView.layer.cornerRadius = imageSize / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0) , size: .init(width: imageSize, height: imageSize))
        cardUserImageView.layer.cornerRadius = imageSize / 2
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
    }
    
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    fileprivate func setupBlurView() {
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss)))
        addSubview(visualEffect)
        visualEffect.fillSuperview()
        visualEffect.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.visualEffect.alpha = 1
        } completion: { (_) in
        }
    }
    
    @objc fileprivate func handleTapToDismiss() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { (_ ) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    fileprivate func setupAnimations() {
        views.forEach({$0.alpha = 1})

        // starting positions
        let angle = 30 * CGFloat.pi / 180

        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))

        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))

        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)

        // keyframe animations for segmented animation

        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {

            // animation 1 - translation back to original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45, animations: {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            })

            // animation 2 - rotation
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            })


        }) { (_) in

        }

        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        })
    }
    
    
}
