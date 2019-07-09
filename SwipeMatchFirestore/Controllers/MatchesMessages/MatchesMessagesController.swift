//
//  MatchesMessagesController.swift
//  SwipeMatchFirestore
//
//  Created by 小森 将大 on 2019/07/04.
//  Copyright © 2019 小森 将大. All rights reserved.
//

import LBTATools
import Firebase

struct RecentMessage {
    let text, uid, name, profileImageUrl: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

class MatchesMessagesController: LBTAListHeaderController<RecentMessageCell, RecentMessage, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    var recentMessagesDictionary = [String: RecentMessage]()
    
    var listener: ListenerRegistration?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            listener?.remove()
        }
    }
    
    deinit {
        print("Reclaiming memory from the MatchesMessagesController")
    }
    
    fileprivate func fetchRecentMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages")
        listener = query.addSnapshotListener { (querySnapshot, err) in
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified {
                    let dictionary = change.document.data()
                    let recentMessage = RecentMessage(dictionary: dictionary)
                    self.recentMessagesDictionary[recentMessage.uid] = recentMessage
                }
            })
            
            self.resetItems()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentMessage = self.items[indexPath.item]
        let dictionary = [
            "name": recentMessage.name,
            "profileImageUrl": recentMessage.profileImageUrl,
            "uid": recentMessage.uid
        ]
        let match = Match(dictionary: dictionary)
        let controller = ChatLogController(match: match)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func resetItems() {
        let values = Array(recentMessagesDictionary.values)
        items = values.sorted(by: { (rm1, rm2) -> Bool in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func setupHeader(_ header: MatchesHeader) {
        header.matchesHorizontalController.rootMatchesController = self
    }
    
    func didSelectMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    let customNavBar = MatchesNavBar()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecentMessages()
        
        items = [
//            .init(text: "Some random message that I'll use for each recent message cell", uid: "BLANK", name: "USERNAME", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/swipematchfirestore-9650a.appspot.com/o/images%2FDB4F63E9-E984-437F-A4CE-69A1632E9EC0?alt=media&token=a9e939ae-23dd-4c61-b8b2-25889db333a6", timestamp: Timestamp(date: .init())),
//            .init(text: "Some random message that I'll use for each recent message cell", uid: "BLANK", name: "USERNAME", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/swipematchfirestore-9650a.appspot.com/o/images%2FDB4F63E9-E984-437F-A4CE-69A1632E9EC0?alt=media&token=a9e939ae-23dd-4c61-b8b2-25889db333a6", timestamp: Timestamp(date: .init()))
        ]
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        collectionView.backgroundColor = .white
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
        collectionView.scrollIndicatorInsets.top = 150
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 130)
    }
}
