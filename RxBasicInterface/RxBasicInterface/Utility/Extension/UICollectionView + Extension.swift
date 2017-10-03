//
//  UICollectionView + Extension.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 02/10/2017.
//  Copyright © 2017 Judson. All rights reserved.
//

import UIKit

extension UICollectionView {

    func registerForCell<T: UICollectionReusableView>(_ cellClass: T.Type, identifier: String? = nil, isNib: Bool = true) {
        let nibName = cellClass.className
        let cellIdentifier = identifier ?? nibName
        if isNib {
            self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        } else {
            self.register(cellClass, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
    
    func dequeueCell<T: UICollectionReusableView>(_ cellClass: T.Type, indexPath: IndexPath) -> T {
        let identifier = cellClass.className
        // swiftlint:disable:next force_cast
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }

}

extension UICollectionReusableView {
    static var className: String {
        return "\(self)"
    }
}

extension UITableViewCell {
    
    static var className: String {
        return "\(self)"
    }
}
