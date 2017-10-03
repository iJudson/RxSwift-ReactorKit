//
//  HomePageReactor.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 02/10/2017.
//  Copyright © 2017 Judson. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class HomePageReactor: Reactor {
    
    // 属性1：用户行为
    enum Action {
        case loadFirstPage
        case loadNextPage
    }
    
    // 属性2：用户行为转换为界面状态的中间
    enum Mutation {
        case setLoadingFirstPage(Bool)
        case fetchedNewestDatas([ListResponseData<HomeList>])
        
        case setLoadingNextPage(Bool)
        case fetchedMoreDatas([ListResponseData<HomeList>], nextPage: Int)
    }
    
    // 属性3：显示到界面上的状态
    struct State {
        var listDatas: [ListResponseData<HomeList>] = []
        var isLoadingNewest: Bool = false
        var isLoadingMore: Bool = false
        var nextPage: Int?
    }
    
    // 属性4：初始化的状态
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    // 方法1：将用户行为转换为显示状态，并返回 Mutation 可观察序列
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .loadFirstPage:
            guard !self.currentState.isLoadingNewest else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingFirstPage(true)),
                
                RequestService.fetchListData(with: .home).flatMap({ (listData) -> Observable<Mutation> in
                    return Observable.just(Mutation.fetchedNewestDatas([listData]))
                }),
                
                Observable.just(Mutation.setLoadingFirstPage(false)),
                
                ])
            
        case .loadNextPage:
            guard let currentPage = self.currentState.nextPage, !self.currentState.isLoadingMore else { return Observable.empty() }
            
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                RequestService.fetchListData(with: .home, page: currentPage).flatMap({ (listData) -> Observable<Mutation> in
                    return Observable.just(Mutation.fetchedMoreDatas([listData], nextPage: currentPage + 1))
                }),
                
                Observable.just(Mutation.setLoadingNextPage(false)),
                
                ])
        }
    }
    
    // 方法2：拿到方法1中的 Mutation ，更新状态
    func reduce(state: State, mutation: Mutation) -> State {
        // 拿到旧的状态值
        var newState = state
        switch mutation {
        case .setLoadingFirstPage(let isRefreshing):
            newState.isLoadingNewest = isRefreshing
            
        case .setLoadingNextPage(let loadingMore):
            newState.isLoadingMore = loadingMore
            
        case .fetchedNewestDatas(let newestDatas):
            newState.listDatas = newestDatas
            // 这里拿第2页作为首页，故接下来应该为第3页的数据
            newState.nextPage = 3
            
        case let .fetchedMoreDatas(appendedDatas, nextPage: nextPage):
            newState.listDatas.append(contentsOf: appendedDatas)
            newState.nextPage = nextPage
        }
        
        return newState
    }

}
