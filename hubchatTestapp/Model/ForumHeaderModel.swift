//
//  ForumHeaderModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ObjectMapper

public class ForumHeaderModel: Mappable {
    var title: String?
    var description: String?
    var logoURLString: String?
    var imageURLString: String?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        logoURLString <- map["image.url"]
        imageURLString <- map["headerImage.url"]
    }
}
