//
//  HomeList.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 02/10/2017.
//  Copyright © 2017 Judson. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class HomeList {
    
    var title: String?
    var imageURLString: String?
    
    init(data: [String: Any]) {
        guard let object = data["post"] as? [String: Any] else {
            return
        }
        self.title = object["title"] as? String
        self.imageURLString = object["image"] as? String
    }
}

struct ListResponseData<Element>: SectionModelType {
    
    var totalCount = 0
    var items: [Element]
    var hasMore = false
    
    init(items: [Element] = []) {
        self.items = items
    }
    
    init(original: ListResponseData, items: [Element]) {
        self = original
        self.items = items
    }
}
