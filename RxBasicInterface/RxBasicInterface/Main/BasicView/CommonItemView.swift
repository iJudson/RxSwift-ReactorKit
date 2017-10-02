//
//  CommonItemView.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/10.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit

enum AlignmentWay {
    // 可有一个子控件 也可有两个控件
    case center(inset: CGFloat) // 四个方向的 insets 都要改动
    case top(inset: CGFloat) // top 方向的 inset
    case bottom(inset: CGFloat)
    case left(inset: CGFloat)
    case right(inset: CGFloat)
    
    // 必有两个子控件 - 文字和图片控件（默认两个控件 centerY 和父控件的对齐） space 这两个子控件相距距离（可左右 可上下）
    case leftTextRightImage(space: CGFloat)
    case leftImageRightText(space: CGFloat)
    case upTextDownImage(space: CGFloat)
    case upImageDownText(space: CGFloat)
}

class CommonItemView: UIButton {
    
    var title: String? {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    var image: UIImage? {
        didSet {
            self.setImage(image, for: .normal)
        }
    }
    
    // 这个方法的调用需要在 1. 当前 titleLabel 的 font 属性设置完后 2. 将该 view 添加到 父 view 之后再设置
    var alignmentStyle: AlignmentWay? {
        didSet {
            guard let alignmentStyle = self.alignmentStyle else {
                return
            }
            updateAlignmentStyle(alignment: alignmentStyle)
        }
    }
    
    convenience init(frame commonFrame: CGRect = CGRect.zero, image: UIImage?, title: String?) {
        self.init(frame: commonFrame)
        self.backgroundColor = UIColor.white
        updateCommonViewData(image: image, title: title)
    }
}

// MARK: - 更新该控件上的数据 以及 更新其风格样式
extension CommonItemView {
    fileprivate func updateCommonViewData(image: UIImage?, title: String?) {
        self.setImage(image, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(UIColor.gray, for: .normal)
    }
    
    fileprivate func updateAlignmentStyle(alignment: AlignmentWay) {
        if self.frame == CGRect.zero {
            self.sizeToFit()
        }
        self.titleLabel?.sizeToFit()
        self.imageView?.sizeToFit()
        let labelWidth = self.titleLabel?.width ?? 0
        let labelHeight = self.titleLabel?.height ?? 0
        let imageWidth = self.imageView?.width ?? 0
        let imageHeight = self.imageView?.height ?? 0
        
        // labelWidthPadding 的作用是尽量让 titleLabel 的 width 更大些
        let labelWidthPadding = max((self.width - labelWidth) * 0.5, 0)
        let imageWidthPadding = max((self.width - imageWidth) * 0.5, 0)
        let controlsHeight = labelHeight + imageHeight
        let controlsWidth = labelWidth + imageWidth
        let constrolVerticalPadding = max((self.height - controlsHeight) * 0.5, 0)
        let constrolHorizontalPadding = max((self.width - controlsWidth) * 0.5, 0)
        
        switch alignment {
        case let .center(inset: inPutInset):
            guard constrolVerticalPadding != 0 && constrolHorizontalPadding != 0 else {
                return
            }
            self.contentEdgeInsets = UIEdgeInsets(top: inPutInset, left: inPutInset, bottom: inPutInset, right: inPutInset)
            
        case let .top(inset: inPutInset):
            guard constrolVerticalPadding != 0  else {
                return
            }
            self.contentEdgeInsets = UIEdgeInsets(top: -constrolVerticalPadding + inPutInset, left: 0, bottom: constrolVerticalPadding - inPutInset, right: 0)
            
        case let .bottom(inset: inPutInset):
            guard constrolVerticalPadding != 0  else {
                return
            }
            self.contentEdgeInsets = UIEdgeInsets(top: constrolVerticalPadding - inPutInset, left: 0, bottom: -constrolVerticalPadding + inPutInset, right: 0)
            
        case let .left(inset: inPutInset):
            guard constrolHorizontalPadding != 0  else {
                return
            }
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: -constrolHorizontalPadding + inPutInset, bottom: 0, right: constrolHorizontalPadding - inPutInset)
            
        case let .right(inset: inPutInset):
            guard constrolHorizontalPadding != 0  else {
                return
            }
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: constrolHorizontalPadding - inPutInset, bottom: 0, right: -constrolHorizontalPadding + inPutInset)
            
        case let .leftTextRightImage(space: space):
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space * 0.5, bottom: 0, right: -labelWidth - space * 0.5)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space * 0.5, bottom: 0, right: imageWidth + space * 0.5)
            
        case let .leftImageRightText(space: space):
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space * 0.5, bottom: 0, right: space * 0.5)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space * 0.5, bottom: 0, right:  -space * 0.5)
            
        case let .upTextDownImage(space: space):
            let labelVerticalInset: CGFloat = (controlsHeight - labelHeight + space) * 0.5
            let labelHorizontalInset: CGFloat = (controlsWidth - labelWidth) * 0.5
            let imageVerticalInset: CGFloat = (controlsHeight - imageHeight + space) * 0.5
            let imageHorizontalInset: CGFloat = (controlsWidth - imageWidth) * 0.5
            self.titleEdgeInsets = UIEdgeInsets(top: -labelVerticalInset, left: -labelHorizontalInset - labelWidthPadding, bottom: labelVerticalInset, right: labelHorizontalInset - labelWidthPadding)
            self.imageEdgeInsets = UIEdgeInsets(top: imageVerticalInset, left: imageHorizontalInset - imageWidthPadding, bottom: -imageVerticalInset, right: -imageHorizontalInset - imageWidthPadding)
            
        case let .upImageDownText(space: space):
            let imageVerticalInset: CGFloat = (controlsHeight - imageHeight + space) * 0.5
            let imageHorizontalInset: CGFloat = (controlsWidth - imageWidth) * 0.5
            let labelVerticalInset: CGFloat = (controlsHeight - labelHeight + space) * 0.5
            let labelHorizontalInset: CGFloat = (controlsWidth - labelWidth) * 0.5
            self.imageEdgeInsets = UIEdgeInsets(top: -imageVerticalInset, left: imageHorizontalInset - imageWidthPadding, bottom: imageVerticalInset, right: -imageHorizontalInset - imageWidthPadding)
            self.titleEdgeInsets = UIEdgeInsets(top: labelVerticalInset, left: -labelHorizontalInset - labelWidthPadding, bottom: -labelVerticalInset, right: labelHorizontalInset - labelWidthPadding)
            
        }
    }
}
