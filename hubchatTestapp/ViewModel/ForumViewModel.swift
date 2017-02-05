//
//  ForumViewModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import Alamofire



protocol ForumViewModelProtocol: class {
    
    var forumData:(title: String, description: String, logoURLString:String, imageURLString:String)? { get }
    var postsData:[(postText:String, imageURLStrings:[String], upvotes: Float,
        user:(username:String, avatarURLString:String))]? { get }
    
    var dataDidChange: ((ForumViewModelProtocol) -> ())? { get set } // is called on changes
    
    init(forumHeader:ForumHeaderModel, posts: [PostModel])
    
    func showForumInfo()
}


class ForumViewModel : ForumViewModelProtocol {
    
    var forumHeaderModel: ForumHeaderModel
    var postsModel: [PostModel]
    
    internal var postsData: [(postText: String, imageURLStrings: [String], upvotes: Float, user: (username: String, avatarURLString: String))]? {
        didSet {
            self.dataDidChange?(self)
        }
    }
    
    
    internal var forumData: (title: String, description: String, logoURLString: String, imageURLString: String)? {
        didSet {
            self.dataDidChange?(self)
        }
    }
    
    
    // Should be implemented in in View
    // View might update its UI based on the data from the ModelView in this handler
    internal var dataDidChange: ((ForumViewModelProtocol) -> ())?
    
    required init(forumHeader:ForumHeaderModel, posts: [PostModel]) {
        self.forumHeaderModel = forumHeader
        self.postsModel = posts
    }
    
    @objc func showForumInfo() {
        
        Alamofire.request("https://api.hubchat.com/v1/forum/photography").responseJSON { response in
            
            print(response.request ?? "empty")  // original URL request
            print(response.response ?? "empty") // HTTP URL response
            print(response.data ?? "empty")     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
                
                //header image, logo, title, description
                let headerImageURLString = JSON.getValue(forKeyPath: ["forum", "headerImage", "url"]) as? String ?? ""
                let logoURLString = JSON.getValue(forKeyPath: ["forum", "image", "url"]) as? String ?? ""
                let title = JSON.getValue(forKeyPath: ["forum", "title"]) as? String ?? ""
                let description = JSON.getValue(forKeyPath: ["forum", "description"]) as? String ?? ""
                
                self.forumHeaderModel = ForumHeaderModel(title:title, description:description,
                                                         logoURLString:logoURLString, imageURLString:headerImageURLString)
                
                self.forumData = (title: title, description: description,
                                  logoURLString:logoURLString, imageURLString:headerImageURLString)
            }
        }
    }
}
