//
//  ForumViewModel.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result
import Alamofire

public class ForumViewModel : NSObject, ForumViewModelling {
    
    fileprivate var forumData: ForumHeaderModel?
    
    public var title: String {
        
        return forumData?.title ?? ""
    }
    
    public var forumDescription: String {
         return forumData?.description ?? ""
    }
    
    public var logoURL: String {
        return forumData?.logoURLString ?? ""
    }
    
    // Should be implemented in in View
    // View might update its UI based on the data from the ModelView in this handler
    public var dataDidChange: ((ForumViewModelling) -> ())?
    
    public var postsViewModel: [PostsViewModelling]? {
        didSet {
            self.dataDidChange?(self)
        }
    }
    
    fileprivate var forumNetworking: ForumNetworking
    fileprivate var logoImage: UIImage?
    
    required public init(forumNetworking: ForumNetworking) {
        self.forumNetworking = forumNetworking
    }
    
    public func getLogoImage(size:CGSize) -> SignalProducer<UIImage?, NoError> {
        if let logoImage = self.logoImage {
            return SignalProducer(value: logoImage).observe(on: UIScheduler())
        }
        else {
            let imageProducer = forumNetworking.requestImage(imageURL: self.logoURL, size:size)
                .take(until: self.reactive.lifetime.ended)
                .on(value: { self.logoImage = $0 })
                .map { $0 as UIImage? }
                .flatMapError { _ in SignalProducer<UIImage?, NoError>(value: nil) }
            
            return SignalProducer(value: nil)
                .concat(imageProducer)
                .observe(on: UIScheduler())
        }
    }
    
    @objc public func updateForumInfo() {
        
        forumNetworking.updateForumInfo(completionHandler: { (response: DataResponse<ForumHeaderModel>) in
            
            switch(response.result) {
            case .success:
                self.forumData = response.result.value!
                break
            case .failure:
                
                print("Updating failed with the error: \(response.result.error?.localizedDescription ?? "None")")
                break
            }
        })
    }    
}
