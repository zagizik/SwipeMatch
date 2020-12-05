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
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedString.append(NSMutableAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .regular)]))
        let professionString = profession != nil ? profession! : "Not available"
        attributedString.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        
        
        var imageUrls = [String]() // empty string array
        if let url = imageUrl1 { imageUrls.append(url) }
//        if imageUrl2 != "" && imageUrl2 != nil { imageUrls.append(imageUrl2!) }
//        if imageUrl3 != "" && imageUrl3 != nil { imageUrls.append(imageUrl3!) }
        if let url = imageUrl2 { imageUrls.append(url) }
        if let url = imageUrl3 { imageUrls.append(url) }
        
        return CardViewModel(uid: self.uid ?? "", imageNames: imageUrls, attributedString: attributedString, textAligment: .left)
    }
}
