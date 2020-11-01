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
    let imageNames: [String]
    let attributedString : NSAttributedString
    let textAligment: NSTextAlignment
    
    init(imageNames: [String], attributedString : NSAttributedString, textAligment: NSTextAlignment){
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAligment = textAligment
    }
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageUrl = imageNames[imageIndex]
//            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    //reactive programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func goToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}

