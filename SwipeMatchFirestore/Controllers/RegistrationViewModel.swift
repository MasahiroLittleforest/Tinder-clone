//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/06/22.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    // Reactive Programming
    var isFormValidObserver: ((Bool) -> ())?
}
