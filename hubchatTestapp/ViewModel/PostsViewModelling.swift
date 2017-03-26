//
//  PostsModelling.swift
//  hubchatTestapp
//
//  Created by Dmitry on 24.03.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol PostsViewModelling {
    
    var postText: String? { get }
    var userName: String? { get }
    var upvotes: Float { get }
    var avatarURL: String { get }
    var postImageURLs: [String]? { get }
    
    func getAvatarImage(size:CGSize) -> SignalProducer<UIImage?, NetworkError>
    
    func getPostsInfo() -> SignalProducer<[PostsViewModelling]?, NetworkError>
}
