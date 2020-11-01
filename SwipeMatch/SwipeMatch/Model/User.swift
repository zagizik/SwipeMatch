//
//  User.swift
//  SwipeMatch
//
//  Created by Александр Банников on 26.10.2020.
//

import UIKit

struct User: ProducesCardViewModel {
    //defingin user properties for user model layer
    var name: String?
    var age: Int?
    var profession: String?
    //    let imageNames: [String]
    var imageUrl1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String ?? ""
//        let imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
//        self.imageNames = [imageUrl1]
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedString.append(NSMutableAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .regular)]))
        let professionString = profession != nil ? profession! : "Not available"
        attributedString.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedString, textAligment: .left)
    }
}
