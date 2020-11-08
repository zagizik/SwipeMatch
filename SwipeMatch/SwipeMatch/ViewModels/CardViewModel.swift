 //
//  CardViewModel.swift
//  SwipeMatch
//
//  Created by Александр Банников on 26.10.2020.
//

import Foundation
import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageUrls: [String]
    let attributedString : NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString : NSAttributedString, textAligment: NSTextAlignment){
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAligment
    }
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageUrl = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    //reactive programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func goToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}

