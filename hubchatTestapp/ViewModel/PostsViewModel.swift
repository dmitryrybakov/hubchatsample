//
//  PostsViewModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 24.03.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result
import Alamofire

public class PostsViewModel: PostsViewModelling {
    
    fileprivate var postData: PostModel?
    
    public var postText: String? {
        return postData?.postText ?? ""
    }
    public var userName: String? {
        return postData?.createdByUser?.userName ?? ""
    }
    public var upvotes: Float {
        return postData?.upvotes ?? 0.0
    }
    public var avatarURL: String {
        return postData?.createdByUser?.avatarURLString ?? ""
    }
    public var postImageURLs: [String]? {
        return postData?.postImages?.map { $0.imageURL ?? "" } ?? []
    }
    
    fileprivate var forumNetworking: ForumNetworking
    fileprivate var avatarImage: UIImage?
    
    // Should be implemented in in View
    // View might update its UI based on the data from the ModelView in this handler
    public var dataDidChange: ((ForumViewModelling) -> ())?
    
    required public init(forumNetworking: ForumNetworking) {
        self.forumNetworking = forumNetworking
    }
    
    public init(postData: PostModel, forumNetworking: ForumNetworking) {
        self.postData = postData
        self.forumNetworking = forumNetworking
    }
    
    public func getAvatarImage(size:CGSize) -> SignalProducer<UIImage?, NetworkError> {
        if let avatarImage = self.avatarImage {
            return SignalProducer(value: avatarImage).observe(on: UIScheduler())
        }
        return forumNetworking.requestImage(imageURL: self.avatarURL, size:size)
    }
    
    public func getPostsInfo() -> SignalProducer<[PostsViewModelling]?, NetworkError> {
        
        func toPostModel(_ post: PostModel) -> PostsViewModelling {
            return PostsViewModel(postData: post, forumNetworking: self.forumNetworking) as PostsViewModelling
        }
        
        return SignalProducer { observer, disposable in
            
            self.forumNetworking.updatePostsInfo(completionHandler: { (response: DataResponse<[PostModel]>) in
                
                switch(response.result) {
                case .success(let data):
                    let postsModel = data.map { toPostModel($0) }
                    observer.send(value: postsModel)
                    observer.sendCompleted()
                    break
                case .failure(let error):
                    print("Updating failed with the error: \(error.localizedDescription)")
                    observer.send(error: NetworkError(error: error as NSError))
                    break
                }
            })
        }
    }

}
