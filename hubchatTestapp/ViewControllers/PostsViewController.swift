//
//  PostsViewController.swift
//  hubchatTestapp
//
//  Created by Dmitry on 05.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import MWPhotoBrowser

class PostsViewController: UITableViewController {
    
    static let kPostsTableViewCellIdentifier = "kPostsTableViewCellIdentifier"
    
    var forumNetworking: ForumNetworking?
    var viewModel: [PostsViewModelling]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var postImageURLs: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePosts()
        //Auto-set the UITableViewCells height (requires iOS8+)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        tableView.register(PostsTableViewCell.self,
                           forCellReuseIdentifier:PostsViewController.kPostsTableViewCellIdentifier)
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nc = self.navigationController {
            nc.navigationBar.transparentNavigationBar()
        }
    }
    
    func updatePosts() {
        
        if let networking = self.forumNetworking {
            PostsViewModel(forumNetworking: networking).getPostsInfo().observe(on: UIScheduler())
                .on(value: { models in
                    self.viewModel = models
                })
                .on(failed: { error in
                    print("Failed \(error.localizedDescription)")
                })
                .on(event: { event in
                    switch event {
                    case .completed, .failed, .interrupted: break
                    default:
                        break
                    }
                })
                .start()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostsViewController.kPostsTableViewCellIdentifier,
                                                 for: indexPath) as! PostsTableViewCell
        
        guard let postsData = self.viewModel,
            postsData.count > indexPath.row else {
            return cell
        }
        cell.viewModel = postsData[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let postsData = self.viewModel,
            postsData.count > indexPath.row else {
                return
        }
        
        let pd = postsData[indexPath.row]
        self.postImageURLs = pd.postImageURLs

        let gallery = MWPhotoBrowser()
        gallery.delegate = self
        
        self.navigationController?.pushViewController(gallery, animated: true)
    }
}

extension PostsViewController: MWPhotoBrowserDelegate {
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        guard let imageURLs = self.postImageURLs,
            UInt(imageURLs.count) > index else {
            return MWPhoto()
        }
        let photo = MWPhoto(url: URL(string: imageURLs[Int(index)]))
        return photo
    }
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        guard let imageURLs = self.postImageURLs else {
            return 0
        }
        return UInt(imageURLs.count)
    }
}
