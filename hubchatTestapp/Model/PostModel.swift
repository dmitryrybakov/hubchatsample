//
//  PostModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ObjectMapper

public class PostModel: Mappable {
    var postText: String?
    var postImages: [PostImageModel]?
    var upvotes: Float?
    var createdByUser: UserModel?
    
    public required init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        postText <- map["rawContent"]
        upvotes <- map["stats.upVotes"]
        createdByUser <- map["createdBy"]
        postImages <- map["entities.images"]
    }
}
