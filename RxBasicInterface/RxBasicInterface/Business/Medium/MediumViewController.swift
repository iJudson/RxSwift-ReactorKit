//
//  MediumViewController.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/9.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MediumViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTopBarControls()
    }
    
    fileprivate func initializeTopBarControls() {
        let navigationBarStyle = NavigationBarStyle()
        let themeStyle = TopPageThemeStyle(columnTitle: ["电影", "电视", "读书"])
        let topPageBar = TopPageBar(themeStyle: themeStyle)
        let navigationBar = NavigationBar(themeStyle: navigationBarStyle)
        navigationBar.addSubview(topPageBar)
        self.view.addSubview(navigationBar)
        
        topPageBar.clickedIndex.asObservable().observeOn(MainScheduler.instance).bind { [weak self] (clickedIndex) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.handlePageItemClickedEvent(selectedIndex: clickedIndex)
        }.disposed(by: disposeBag)
    }
    
    // 处理页面被选中的事件
    fileprivate func handlePageItemClickedEvent(selectedIndex: Int) {
        
    }
}

