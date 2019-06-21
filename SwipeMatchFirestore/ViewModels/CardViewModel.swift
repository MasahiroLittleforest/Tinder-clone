//
//  CardViewModel.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/06/20.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    // we'll define the properties that are view will display/render out
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}


// what exactly do we do with this card view model thing???
