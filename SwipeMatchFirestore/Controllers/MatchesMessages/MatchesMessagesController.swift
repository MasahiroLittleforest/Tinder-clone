//
//  MatchesMessagesController.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/07/04.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import LBTATools
import Firebase

struct Match {
    let name, profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

class MatchCell: LBTAListCell<Match> {
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: #colorLiteral(red: 0.2550676465, green: 0.2552897036, blue: 0.2551020384, alpha: 1), textAlignment: .center, numberOfLines: 2)
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        stack(stack(profileImageView, alignment: .center), usernameLabel)
    }
}

class MatchesMessagesController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
    let customNavBar = MatchesNavBar()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        items = [
//            .init(name: "test", profileImageUrl: "profile url"),
//            .init(name: "1", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/swipematchfirestore-9650a.appspot.com/o/images%2FDB4F63E9-E984-437F-A4CE-69A1632E9EC0?alt=media&token=a9e939ae-23dd-4c61-b8b2-25889db333a6"),
//            .init(name: "2", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/swipematchfirestore-9650a.appspot.com/o/images%2F7A8CDDE6-6A05-4881-AD3F-8816020376CB?alt=media&token=8a37b697-6ad1-4168-93ab-364475264b22")
//        ]
        
        fetchMatches()
        
        collectionView.backgroundColor = .white
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
    }
    
    fileprivate func fetchMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Failed to fetch matches:", err)
                return
            }
            
            print("Here are my matches documents")
            
            var matches = [Match]()
            
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })
            
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
