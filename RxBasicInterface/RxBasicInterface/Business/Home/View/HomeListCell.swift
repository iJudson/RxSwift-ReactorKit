//
//  HomeListCell.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 02/10/2017.
//  Copyright © 2017 Judson. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import Kingfisher

class HomeListCell: UICollectionViewCell, StoryboardView {
    typealias Reactor = HomeListCellReactor
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var feedNumberLabel: UILabel!
    
    var feedNumber: Int = 0 {
        didSet {
            feedNumberLabel.text = "F\(feedNumber)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        basicInitialization()
    }
    
    fileprivate func basicInitialization() {
        coverImageView.layer.cornerRadius = 2
        coverImageView.layer.masksToBounds = true
    }
    
    func bind(reactor: Reactor) {
        self.titleLabel.text = reactor.currentState.title
        
        if let urlString = reactor.currentState.imageURLString {
            self.coverImageView.kf.setImage(with: URL(string: urlString))
        }
    }
}
