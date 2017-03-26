//
//  PostImageModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 17.03.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ObjectMapper

public class PostImageModel: Mappable {
    var imageURL: String?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        imageURL <- map["cdnUrl"]
    }
}
