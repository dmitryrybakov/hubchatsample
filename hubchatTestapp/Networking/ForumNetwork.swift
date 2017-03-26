//
//  ForumNetwork.swift
//  hubchatTestapp
//
//  Created by Dmitry on 24.03.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import AlamofireImage
import ReactiveSwift

class ForumNetwork: ForumNetworking {
    func updateForumInfo(completionHandler: @escaping (DataResponse<ForumHeaderModel>) -> ()) {
        Alamofire.request(ServerURLAPIConstants.forumURLString).responseObject { (response: DataResponse<ForumHeaderModel>) in
            completionHandler(response)
        }
    }
    
    func updatePostsInfo(completionHandler: @escaping (DataResponse<[PostModel]>) -> ()) {
        
        Alamofire.request(ServerURLAPIConstants.postsURLString).responseArray(keyPath:"posts") { (response: DataResponse<[PostModel]>) in
            completionHandler(response)
        }
    }
    
    func requestImage(imageURL:String, size:CGSize) -> SignalProducer<UIImage?, NetworkError> {
        return SignalProducer { observer, disposable in
            Alamofire.request(imageURL).responseImage { response in
                switch response.result {
                case .success(let image):
                    let filter = AspectScaledToFillSizeCircleFilter(size: size)
                    observer.send(value: filter.filter(image))
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: NetworkError(error: error as NSError))
                }
            }
        }
    }
}
