//
//  MatchesHeader.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/07/08.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import LBTATools

class MatchesHeader: UICollectionReusableView {
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1))
    
    let matchesHorizontalController = MatchesHorizontalController()
    
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack(
            stack(newMatchesLabel).padLeft(20),
            matchesHorizontalController.view,
            stack(messagesLabel).padLeft(20),
            spacing: 20
            ).withMargins(.init(top: 20, left: 0, bottom: 8, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
