//
//  CardView.swift
//  SwipeMatch
//
//  Created by Александр Банников on 25.10.2020.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    //Configurations
    let threshold: CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {

        switch gesture.state {
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
    
    fileprivate func handleEndedCase(_ gesture: UIPanGestureRecognizer) {
        let shouldDismissCard = gesture.translation(in: nil).x > threshold
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            if shouldDismissCard {
                self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)
//                let offScreenTransorm = self.transform.translatedBy(x: 1000, y: 0)
//                self.transform = offScreenTransorm
            } else {
                self.transform = .identity
            }
        } completion: { (_) in
            self.transform = .identity
            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
