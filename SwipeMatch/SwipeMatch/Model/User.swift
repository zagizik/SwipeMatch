//
//  User.swift
//  SwipeMatch
//
//  Created by Александр Банников on 26.10.2020.
//

import UIKit

struct User: ProducesCardViewModel {
    //defingin user properties for user model layer
    let name: String
    let age: Int
    let profession: String
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedString.append(NSMutableAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .regular)]))
        attributedString.append(NSMutableAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        
        return CardViewModel(imageNames: imageNames, attributedString: attributedString, textAligment: .left)
    }
}
