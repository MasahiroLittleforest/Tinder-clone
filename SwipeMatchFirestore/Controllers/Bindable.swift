//
//  Bindable.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/06/22.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
