//
//  NavigationBar.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/10.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias BarItemElement = (image: UIImage?, title: String?)
let navigationBarHeight: CGFloat = 64.0
let statusBarHeight: CGFloat = 22.0
let commonItemWidth: CGFloat = 64.0

enum ItemPosition {
    case left, center, right, none
}

struct NavigationBarStyle {
    var leftItemStyle: BarItemElement?
    var centerItemStyle: BarItemElement?
    var rightItemStyle: BarItemElement?
    var hasBottomLine: Bool = true
    var themeColor: UIColor = UIColor.white
    
    init(left: BarItemElement? = nil, center: BarItemElement? = nil, right: BarItemElement? = nil) {
        self.leftItemStyle = left
        self.centerItemStyle = center
        self.rightItemStyle = right
    }
}

class NavigationBar: UIView {
    
    var themeStyle: NavigationBarStyle = NavigationBarStyle() {
        didSet {
            update(ThemeStyle: themeStyle)
        }
    }
    
    // bar 上三个位置上(左、中、右)的点击事情，默认无点击事件
    var clickedIndex = PublishSubject<Int>()
    
    fileprivate let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect? = nil, themeStyle: NavigationBarStyle) {
        let barFrame = frame ?? CGRect(x: 0, y: 0, width: screenWidth, height: navigationBarHeight)
        self.init(frame: barFrame)
        self.themeStyle = themeStyle
        self.backgroundColor = themeStyle.themeColor
        update(ThemeStyle: themeStyle)
        add(BottomLine: themeStyle.hasBottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NavigationBar {
    
    fileprivate func update(ThemeStyle style: NavigationBarStyle) {
        update(ItemStyle: style.leftItemStyle, postion: .left)
        update(ItemStyle: style.centerItemStyle, postion: .center)
        update(ItemStyle: style.rightItemStyle, postion: .right)
        
    }
    
    fileprivate func update(ItemStyle barStyle: BarItemElement?, postion: ItemPosition) {
        
        guard let style = barStyle, postion != .none else {
            return
        }
        
        var itemTag: Int = -1
        var itemFrame = CGRect.zero
        
        switch postion {
        case .left:
            itemFrame = CGRect(x: 0, y: statusBarHeight, width: commonItemWidth, height: navigationBarHeight - statusBarHeight)
            itemTag = 0
            
        case .center:
            itemFrame = CGRect(x: commonItemWidth, y: statusBarHeight, width: screenWidth - 2 * commonItemWidth, height: navigationBarHeight - statusBarHeight)
            itemTag = 1
            
        case .right:
            itemFrame = CGRect(x: screenWidth - commonItemWidth, y: statusBarHeight, width: commonItemWidth, height: navigationBarHeight - statusBarHeight)
            itemTag = 2
            
        default:
            break
            
        }
        
        let commonIem = CommonItemView(frame: itemFrame, image: style.image, title: style.title)
        commonIem.backgroundColor = themeStyle.themeColor
        commonIem.tag  = itemTag
        self.addSubview(commonIem)
        
        // 点击事件的监控处理
        commonIem.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            self.clickedIndex.onNext(itemTag)
        }).disposed(by: disposeBag)
    }
    
    fileprivate func add(BottomLine isExisting: Bool) {
        guard isExisting else {
            return
        }
        let bottomLine = UIView(frame: CGRect(x: 0, y: navigationBarHeight, width: screenWidth, height: 0.5))
        bottomLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.addSubview(bottomLine)
    }
}
