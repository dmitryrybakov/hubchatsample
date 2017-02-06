//
//  ForumHeaderViewController.swift
//  hubchatTestapp
//
//  Created by Dmitry on 03.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage
import RZTransitions

@objc(ForumHeaderViewController)
class ForumHeaderViewController: UIViewController {
    
    let showForumButton = UIButton()
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()
    var pushPopInteractionController: RZTransitionInteractionController?
    
    var viewModel: ForumViewModelProtocol! {
        didSet {
            self.viewModel.dataDidChange = { [unowned self] viewModel in
                
                if  let forumData = viewModel.forumData {
                    self.titleLabel.text = forumData.title
                    self.descriptionLabel.text = forumData.description
                    
                    Alamofire.request(forumData.logoURLString).responseImage { response in
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            let filter = AspectScaledToFillSizeCircleFilter(size: self.logoImageView.bounds.size)
                            self.logoImageView.image = filter.filter(image)
                        }
                    }
                    let imageURL = URL(string: forumData.imageURLString)!
                    self.imageView.af_setImage(withURL:imageURL)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view = UIView(frame:CGRect.zero)
        
        self.showForumButton.setTitle("Test Button", for: .normal)
        self.showForumButton.isHidden = true
        
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 48.0)
        self.titleLabel.textColor = .white
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.5
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.lineBreakMode = .byWordWrapping
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 36.0)
        self.descriptionLabel.textColor = .white
        self.descriptionLabel.adjustsFontSizeToFitWidth = true
        self.descriptionLabel.minimumScaleFactor = 0.5
        
        self.view.addSubview(imageView)
        self.view.addSubview(logoImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(showForumButton)
        
        showForumButton.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).inset(50)
            make.leading.equalTo(self.view).inset(15)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.top)
            make.left.equalTo(self.logoImageView.snp.right)
            make.height.equalTo(self.logoImageView.snp.height)
            make.trailing.equalTo(self.view).inset(15)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.bottom.equalTo(self.view).inset(0)
            make.leading.equalTo(self.view).inset(15)
            make.trailing.equalTo(self.view).inset(15)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).inset(0)
            make.trailing.equalTo(self.view).inset(0)
            make.top.equalTo(self.view).inset(0)
            make.bottom.equalTo(self.view).inset(0)
        }
        
        self.showForumButton.addTarget(self.viewModel, action: Selector(("showForumInfo")), for: .touchUpInside)
        
        self.viewModel.updateForumInfo()
        
        pushPopInteractionController = RZHorizontalInteractionController()
        if let vc = pushPopInteractionController as? RZHorizontalInteractionController {
            vc.nextViewControllerDelegate = self
            vc.attach(self, with: .pushPop)
            RZTransitionsManager.shared().setInteractionController( vc,
                                                                    fromViewController:type(of: self),
                                                                    toViewController:nil,
                                                                    for: .pushPop);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nc = self.navigationController {
            nc.navigationBar.transparentNavigationBar()
        }
    }
}


extension ForumHeaderViewController: RZTransitionInteractionControllerDelegate {
    
    func nextSimpleViewController() -> UIViewController {
        let newVC = PostsViewController()
        newVC.viewModel = self.viewModel
        newVC.transitioningDelegate = RZTransitionsManager.shared()
        return newVC
    }
    
    func nextViewController(forInteractor interactor: RZTransitionInteractionController!) -> UIViewController! {
        return nextSimpleViewController()
    }
}
