//
//  Match.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/07/08.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import Foundation

struct Match {
    let name, profileImageUrl, uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
