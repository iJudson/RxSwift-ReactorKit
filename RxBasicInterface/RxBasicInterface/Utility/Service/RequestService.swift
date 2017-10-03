//
//  RequestService.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 02/10/2017.
//  Copyright © 2017 Judson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ListDataType {
    case home, medium, broadcast, group, profile
}

// 这是网络服务模块，功能是拿到网络数据
class RequestService {
    static let shared = RequestService()
    private init() { }
    
    // 网络这一块不是我们这次的重点，所以这里用最简单的方式进行网络请求
    static func fetchListData(with type: ListDataType, page: Int = 2) -> Observable<ListResponseData<HomeList>> {
        var queryURL: URL?
        let emptyResult: ListResponseData<HomeList> = ListResponseData(items: [])
        
        // 这里暂且只演示首页模块，其他模块待续
        switch type {
        case .home:
            // 本来这个地方需要拼接参数的，这里不是重点，所以我们直接拼接到 URL 后面
            let queryStr = "http://app3.qdaily.com/app3/columns/index/\(page)/0.json"
            queryURL = URL(string: queryStr)
        
        default:
            break
        }
        guard let url = queryURL else { return Observable.empty() }
        return URLSession.shared.rx.json(url: url)
            .map { json -> ListResponseData<HomeList> in
                guard let dict = json as? [String: Any] else { return emptyResult }
                guard let response = dict["response"] as? [String: Any], let feeds = response["feeds"] as? [[String: Any]] else { return emptyResult }
                // JSON 数据的处理
                var elements: [HomeList] = []
                for feed in feeds {
                    let listData = HomeList(data: feed)
                    elements.append(listData)
                }
                print("itemsCount  \(feeds.count)")
                let listResponseData = ListResponseData(items: elements)
                return listResponseData
            }
            .do(onError: { error in
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
                    print("There is some wrongs with your network. Please check the setting and try again.")
                }
            })
            .catchErrorJustReturn(emptyResult)
    }
}
