//
//  UserModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ObjectMapper

public class UserModel: Mappable {
    var userName: String?
    var avatarURLString: String?
    
    public required init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        userName <- map["username"]
        avatarURLString <- map["avatar.url"]
    }
}
