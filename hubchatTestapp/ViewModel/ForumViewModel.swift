//
//  ForumViewModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import Alamofire

enum ServerURLAPIConstants {
    static let forumURLString = "https://api.hubchat.com/v1/forum/photography"
    static let postsURLString = "https://api.hubchat.com/v1/forum/photography/post"
}

protocol ForumViewModelProtocol: class {
    
    var forumData:(title: String, description: String, logoURLString:String, imageURLString:String)? { get }
    var postsData:[(postText:String, imageURLStrings:[String], upvotes: Float,
        user:(username:String, avatarURLString:String))]? { get }
    
    var dataDidChange: ((ForumViewModelProtocol) -> ())? { get set } // is called on changes
    
    init(forumHeader:ForumHeaderModel, posts: [PostModel])
    
    func updateForumInfo()
    func updatePostsInfo()
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
    
    @objc func updateForumInfo() {
        
        Alamofire.request(ServerURLAPIConstants.forumURLString).responseJSON { response in
            
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
    
    @objc func updatePostsInfo() {
        
        Alamofire.request(ServerURLAPIConstants.postsURLString).responseJSON { response in
            
            if let JSON = response.result.value as? Dictionary<String, AnyObject> {
                
                var posts: [(postText:String, imageURLStrings:[String], upvotes: Float,
                              user:(username:String, avatarURLString:String))] = []
                var postsModel:[PostModel] = []
                
                let postsJSON = JSON.getValue(forKeyPath: ["posts"])
                
                for postObject in (postsJSON as? [Dictionary<String, AnyObject>])! {
                    
                    let postText = postObject.getValue(forKeyPath: ["rawContent"]) as? String ?? ""
                    let upVotes = postObject.getValue(forKeyPath: ["stats", "upVotes"]) as? Float ?? 0.0
                    let avatarURLString = postObject.getValue(forKeyPath: ["createdBy", "avatar", "url"]) as? String ?? ""
                    let username = postObject.getValue(forKeyPath: ["createdBy", "username"]) as? String ?? ""
                    let imagesObject = postObject.getValue(forKeyPath: ["entities", "images"])
                    
                    var imagesURLStringArray:[String] = []
                    for imageObject in (imagesObject as? [Dictionary<String, AnyObject>])! {
                        
                        if let URLString = imageObject.getValue(forKeyPath: ["cdnUrl"]) as? String {
                        
                            imagesURLStringArray.append(URLString)
                        }
                    }
                    
                    posts.append((postText: postText, imageURLStrings:imagesURLStringArray,
                                  upvotes:upVotes, (username:username, avatarURLString:avatarURLString)))
                    postsModel.append(PostModel(postText: postText, imageURLStrings: imagesURLStringArray,
                                                upvotes: upVotes, user: UserModel(userName: username, avatarURLString: avatarURLString)))
                }
                
                if posts.count > 0 {
                    self.postsModel = postsModel
                    self.postsData = posts
                }
            }
        }
    }
}
