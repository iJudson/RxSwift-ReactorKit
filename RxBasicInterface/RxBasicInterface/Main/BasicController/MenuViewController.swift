//
//  MenuViewController.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/10.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MenuViewController: UIViewController {
    
    // Status Bar Animation handle
    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.prefersStatusBarHidden ?? false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return selectedViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .all
    }
    
    fileprivate let disposeBag = DisposeBag()
    // 顶部视图容器
    fileprivate var topViewControllers: [UIViewController] = []
    // 当前被选中显示的顶部视图容器
    fileprivate var selectedViewController: UIViewController?
    // 默认选中首页
    fileprivate var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTopViewControllers()
        
        configureTabBar()
    }
    
    fileprivate func initializeTopViewControllers() {
        let homeNav = UIStoryboard.NavigationController.home
        let mediumNav = UIStoryboard.NavigationController.medium
        let broadcastNav = UIStoryboard.NavigationController.broadcast
        let groupNav = UIStoryboard.NavigationController.group
        let profileNav = UIStoryboard.NavigationController.profile
        topViewControllers = [homeNav, mediumNav, broadcastNav, groupNav, profileNav]
        
        // 初始化时，默认选中首页
        self.addChildViewController(homeNav)
        homeNav.view.frame = self.view.bounds
        self.view.addSubview(homeNav.view)
        self.selectedViewController = homeNav
        self.setNeedsStatusBarAppearanceUpdate()
    }

    fileprivate func configureTabBar() {
        
        let barItemElements: [TabBarItemElement] = [
            (normalImage: UIImage(named: "ic_tab_home_gray_32x32_"), selectedImage: UIImage(named: "ic_tab_home_32x32_"), title: "首页"),
            (normalImage: UIImage(named: "ic_tab_subject_gray_32x32_"), selectedImage: UIImage(named: "ic_tab_subject_32x32_"), title: "书影音"),
            (normalImage: UIImage(named: "ic_tab_timeline_gray_32x32_"), selectedImage: UIImage(named: "ic_tab_timeline_32x32_"), title: "广播"),
            (normalImage: UIImage(named: "ic_tab_group_gray_32x32_"), selectedImage: UIImage(named: "ic_tab_group_32x32_"), title: "小组"),
            (normalImage: UIImage(named: "profile_normal_32x32_"), selectedImage: UIImage(named: "profile_active_32x32_"), title: "我的")
        ]
        
        let tabBarStyle = TabBarStyle(elements: barItemElements)
        let tabBarView = TabBarView(themeStyle: tabBarStyle)
        self.view.addSubview(tabBarView)
        
        tabBarView.selectedIndex.asObservable().observeOn(MainScheduler.instance).bind { [weak self] (clickedIndex) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.handleTopControllerSelectionEvent(currentIndex: clickedIndex)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func handleTopControllerSelectionEvent(currentIndex: Int) {
        if let selectedViewController = selectedViewController {
            selectedViewController.willMove(toParentViewController: nil)
            selectedViewController.view.removeFromSuperview()
            selectedViewController.removeFromParentViewController()
            selectedViewController.viewWillDisappear(false)
        }
        
        let currentSelectedViewController = topViewControllers[currentIndex]
        self.addChildViewController(currentSelectedViewController)
        currentSelectedViewController.view.frame = self.view.bounds
        self.view.addSubview(currentSelectedViewController.view)
        currentSelectedViewController.didMove(toParentViewController: self)
        self.selectedViewController = currentSelectedViewController
        self.setNeedsStatusBarAppearanceUpdate()
        self.selectedIndex = currentIndex
        
        // 置顶 TabBar
        for subView in self.view.subviews {
            if let tabBar = subView as? TabBarView {
                self.view.bringSubview(toFront: tabBar)
            }
        }
    }
    
}

  
