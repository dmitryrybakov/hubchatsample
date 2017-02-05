//
//  PostsViewController.swift
//  hubchatTestapp
//
//  Created by Dmitry on 05.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class PostsViewController: UITableViewController {
    
    static let kPostsTableViewCellIdentifier = "kPostsTableViewCellIdentifier"
    
    var viewModel: ForumViewModelProtocol! {
        didSet {
            self.viewModel.dataDidChange = { [unowned self] viewModel in
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.updatePostsInfo()
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        tableView.register(PostsTableViewCell.self,
                           forCellReuseIdentifier:PostsViewController.kPostsTableViewCellIdentifier)
        self.tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let postData = self.viewModel.postsData {
            return postData.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostsViewController.kPostsTableViewCellIdentifier,
                                                 for: indexPath) as! PostsTableViewCell
        
        if let postsData = self.viewModel.postsData {
            if postsData.count > indexPath.row {

                let pd = postsData[indexPath.row]
                cell.postTextLabel.text = pd.postText
                cell.userNameLabel.text = pd.user.username
                cell.upVotesLabel.text = String(pd.upvotes)
                
                Alamofire.request(pd.user.avatarURLString).responseImage { response in
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        let filter = AspectScaledToFillSizeCircleFilter(size: cell.avatarImageView.bounds.size)
                        cell.avatarImageView.image = filter.filter(image)
                    }
                }
            }
        }
        
        return cell
    }
}
