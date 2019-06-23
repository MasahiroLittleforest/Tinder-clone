//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/06/19.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
//    let cardViewModels: [CardViewModel] = {
//        let producers = [
//            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
//            Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster"),
//            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1", "jane2", "jane3"])
//        ] as [ProducesCardViewModel]
//
//        let viewModels = producers.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
    
    var cardViewModels = [CardViewModel]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }
    
    fileprivate func fetchUsersFromFirestore() {
        let query = Firestore.firestore().collection("users")
//        let query = Firestore.firestore().collection("users").whereField("friends", arrayContains: "Chris")
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            
            self.setupFirestoreUserCards()
        }
    }
    
    @objc func handleSettings() {
        print("Show registration page")
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
    }

    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }

}

