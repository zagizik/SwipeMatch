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

struct CardViewModel {
    let imageName: String
    let attributedString : NSAttributedString
    let textAligment: NSTextAlignment
}


