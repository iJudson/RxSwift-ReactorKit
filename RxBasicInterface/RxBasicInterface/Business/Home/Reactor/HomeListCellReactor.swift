//
//  HomeListCellReactor.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 02/10/2017.
//  Copyright © 2017 Judson. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class HomeListCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: HomeList
    
    init(data: HomeList) {
        self.initialState = data
    }
    
}
