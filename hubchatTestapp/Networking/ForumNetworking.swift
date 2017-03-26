//
//  ForumNetworking.swift
//  hubchatTestapp
//
//  Created by Dmitry on 24.03.17.
//  Copyright © 2017 hubchat. All rights reserved.
//
import Alamofire
import AlamofireObjectMapper
import ReactiveSwift

public protocol ForumNetworking {
    func updateForumInfo(completionHandler: @escaping (DataResponse<ForumHeaderModel>) -> ())
    func updatePostsInfo(completionHandler: @escaping (DataResponse<[PostModel]>) -> ())
    func requestImage(imageURL:String, size:CGSize) -> SignalProducer<UIImage?, NetworkError>
}
