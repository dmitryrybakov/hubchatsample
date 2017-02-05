//
//  PostModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation

struct PostModel {
    let postText: String
    let imageURLStrings: [String]
    let upvotes: Float
    let user: UserModel
}
