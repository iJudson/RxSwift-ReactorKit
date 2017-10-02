//
//  ProfileViewController.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/9.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTopBarControls()
    }
    
    fileprivate func initializeTopBarControls() {
        let barStyle = NavigationBarStyle(center: (image: nil, title: "我的"))
        let navigationBar = NavigationBar(themeStyle: barStyle)
        self.view.addSubview(navigationBar)
    }
    
}
  
