//
//  EventFeedCell.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 18.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class EventFeedCell: UITableViewCell {
    
    @IBOutlet weak var contentButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    
    private enum Constants {
        static let unreadCornerRadius = CGFloat(8.0)
        static let iconCornerRadius = CGFloat(20.0)
        static let maxContentLength  = 300
        static let mainViewCornerRadius = CGFloat(10.0)
        static let contentButtonHeight = CGFloat(30.0)
        static let photoButtonHeight = CGFloat(150.0)
    }
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentButton.imageView?.contentMode = .scaleAspectFit
        unreadView.layer.cornerRadius = Constants.unreadCornerRadius
        unreadView.clipsToBounds = true
        typeImage.layer.cornerRadius = Constants.iconCornerRadius
        typeImage.clipsToBounds = true
        applyTranslations()
        bgView.layer.cornerRadius = Constants.mainViewCornerRadius
        bgView.clipsToBounds = true
        bgView.dropShadow()
    }
    
    
    func set(title: Observable<String>, date: Observable<String>, content: Observable<String>, unread: Observable<Bool>, imageName: Observable<String>, videoUrl: Observable<String?>, imageUrl: Observable<String?>, contentUrl: Observable<String?>) {
        unread.bind { unread in
            self.unreadView.isHidden = !unread
        }.addDisposableTo(disposeBag)
        title.bind(to: titleLabel.rx.text).addDisposableTo(disposeBag)
        content.bind { content in
            self.contentLabel.text = content.truncate(length: Constants.maxContentLength, trailing: "...")
        }.addDisposableTo(disposeBag)
        date.bind(to: dateLabel.rx.text).addDisposableTo(disposeBag)
        imageName.bind { name in
            self.typeImage.image = UIImage(named: name)
        }.addDisposableTo(disposeBag)
        
        Observable.combineLatest(videoUrl, imageUrl, contentUrl) { video, image, content -> CGFloat in
            if image != nil {
                return Constants.photoButtonHeight
            }
            if video != nil || content != nil {
                return Constants.contentButtonHeight
            }
            return CGFloat(0)
        }.bind(to: contentButtonHeightConstraint.rx.constant).addDisposableTo(disposeBag)
        
        imageUrl.asObservable().bind { imageUrl in
            guard let imageUrl = imageUrl else {
                return
            }
            KingfisherManager.shared.retrieveImage(with: URL(string: imageUrl)!, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                guard let image = image else { return self.contentButton.setBackgroundImage(UIImage(), for: .normal) }
                let desiredWidth = self.contentButton.frame.width
                let ratio = image.size.width / desiredWidth
                let desiredHeight = image.size.height / ratio
                self.contentButtonHeightConstraint.constant = desiredHeight
                self.contentButton.setBackgroundImage(image, for: .normal)
                self.layoutIfNeeded()
            })
        }.addDisposableTo(disposeBag)
 
    }
    
}

extension EventFeedCell: Translatable {
    func applyTranslations() {
        moreLabel.text = "more_label".localized
    }
}
