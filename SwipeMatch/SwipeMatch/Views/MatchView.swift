//
//  MatchView.swift
//  SwipeMatch
//
//  Created by Александр Банников on 22.11.2020.
//

import UIKit

class MatchView: UIView {

    override init(frame: CGRect){
        super.init(frame: frame)
        setupBlurView()
    }
    
    fileprivate func setupBlurView() {
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss)))
        addSubview(visualEffect)
        visualEffect.fillSuperview()
        visualEffect.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            visualEffect.alpha = 1
        } completion: { (_ ) in
            print("meh")
        }

    }
    
    @objc fileprivate func handleTapToDismiss() {
        removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
