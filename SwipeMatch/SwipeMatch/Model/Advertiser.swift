//
//  Advertiser.swift
//  SwipeMatch
//
//  Created by Александр Банников on 26.10.2020.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string:  title, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: . heavy)])
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 26, weight: . bold)]))
        
        return CardViewModel(imageName: posterPhotoName, attributedString: attributedString, textAligment: .center)
    }
}
