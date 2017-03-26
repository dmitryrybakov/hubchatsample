//
//  PostsTableViewCell.swift
//  hubchatTestapp
//
//  Created by Dmitry on 05.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PostsTableViewCell: UITableViewCell {
    
    let avatarImageView = UIImageView()
    let userNameLabel = UILabel()
    let upVotesLabel = UILabel()
    let postTextLabel = UILabel()
    
    var viewModel: PostsViewModelling? {
        didSet {
            self.postTextLabel.text = viewModel?.postText
            self.userNameLabel.text = viewModel?.userName
            self.upVotesLabel.text = String(describing: viewModel?.upvotes)
            self.avatarImageView.image = UIImage(named: "placeholder-image")
            
            if let viewModel = viewModel {
                viewModel.getAvatarImage(size: self.avatarImageView.bounds.size)
                    .take(until: self.reactive.prepareForReuse)
                    .on(value: { self.avatarImageView.image = ($0 ?? UIImage(named: "placeholder-image")) })
                    .start()
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(avatarImageView)
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(upVotesLabel)
        self.contentView.addSubview(postTextLabel)
        
        self.postTextLabel.numberOfLines = 0
        self.postTextLabel.lineBreakMode = .byWordWrapping
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(15)
            make.leading.equalTo(self.contentView).inset(15)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp.top)
            make.left.equalTo(self.avatarImageView.snp.right).inset(-15)
            make.bottom.equalTo(self.avatarImageView.snp.centerY)
            make.trailing.equalTo(self.contentView).inset(15)
        }
        
        upVotesLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.userNameLabel.snp.left)
            make.right.equalTo(self.userNameLabel.snp.right)
            make.top.equalTo(self.avatarImageView.snp.centerY)
            make.bottom.equalTo(self.avatarImageView.snp.bottom)
            make.trailing.equalTo(self.contentView).inset(15)
        }
        
        postTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-15)
            make.trailing.equalTo(self.contentView).inset(15)
            make.leading.equalTo(self.contentView).inset(15)
            make.bottom.equalTo(self.contentView).inset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
