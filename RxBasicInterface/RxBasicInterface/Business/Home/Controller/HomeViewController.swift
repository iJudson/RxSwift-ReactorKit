//
//  HomeViewController.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/9.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources

class HomeViewController: UIViewController, StoryboardView {
    typealias Reactor = HomePageReactor
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<ListResponseData<HomeList>>()
    
    // 存储一些该类的常量
    struct Constant {
        static let refreshTriggerValue: CGFloat = -60
        static let cellSize = CGSize(width: screenWidth, height: 135)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTopBarControls()
        configure(for: collectionView)
    }
    
    func bind(reactor: Reactor) {
        // DataSource && Delegate
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        self.dataSource.configureCell = { _, collectionView, indexPath, element in
        let cell = collectionView.dequeueCell(HomeListCell.self, indexPath: indexPath)
        cell.reactor = HomeListCellReactor(data: element)
        cell.feedNumber = indexPath.item + 1
        return cell
        }
        
        // Action(View -> Reactor)
        collectionView.rx.contentOffset
            .filter { [weak self] offset in
                guard let strongSelf = self else { return false }
                guard strongSelf.collectionView.height > 0 else { return false }
                return ((offset.y < Constant.refreshTriggerValue || strongSelf.collectionView.contentSize.height == 0) ? true : false)
            }
            .map { _ in Reactor.Action.loadFirstPage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        collectionView.rx.contentOffset
            .filter { [weak self] offset in
                guard let strongSelf = self else { return false }
                guard strongSelf.collectionView.contentSize.height > 0 else { return false }
                return (offset.y + strongSelf.collectionView.height + 50 > strongSelf.collectionView.contentSize.height ? true : false)
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State(Reactor -> View)
        reactor.state.asObservable()
            .map { $0.listDatas }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constant.cellSize
    }
}

extension HomeViewController {
    
    fileprivate func initializeTopBarControls() {
        let barStyle = NavigationBarStyle(center: (image: nil, title: "首页"))
        let navigationBar = NavigationBar(themeStyle: barStyle)
        self.view.addSubview(navigationBar)
    }
    
    fileprivate func configure(for currentCollectionView: UICollectionView) {
        currentCollectionView.registerForCell(HomeListCell.self)
    }
}


