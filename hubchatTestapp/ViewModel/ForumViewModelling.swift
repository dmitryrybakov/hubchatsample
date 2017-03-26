//
//  ForumViewModelling.swift
//  hubchatTestapp
//
//  Created by Dmitry on 24.03.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol ForumViewModelling: class {
    
    var title: String { get }
    var forumDescription: String { get }
    var logoURL: String { get }
    
    var dataDidChange: ((ForumViewModelling) -> ())? { get set } // is called on changes
    
    func getLogoImage(size:CGSize) -> SignalProducer<UIImage?, NoError>
    
    func updateForumInfo()
}
