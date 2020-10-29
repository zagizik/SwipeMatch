//
//  RegistrationViewModel.swift
//  SwipeMatch
//
//  Created by Александр Банников on 28.10.2020.
//

import UIKit

class RegistrationViewModel {
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
//    var image: UIImage? {
//        didSet {
//            imageObserver?(image)
//        }
//    }

    
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
//        isFormValidObserver?(isFormValid)
    }

    
    //reactive shiiieeeeet
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
//    var isFormValidObserver: ((Bool) -> ())?
//    var imageObserver: ((UIImage?) -> ())?
}
