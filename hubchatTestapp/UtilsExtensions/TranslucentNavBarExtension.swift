//
//  TranslucentNavBarExtension.swift
//  hubchatTestapp
//
//  Created by Dmitry on 05.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
