//
//  FeedEntryViewModel.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 19.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import RxSwift
import RxCocoa

class FeedEntryViewModel {
    var title = Variable<String>("")
    var content = Variable<String>("")
    var date = Variable<String>("")
    var iconName = Variable<String>("")
    var videoUrl = Variable<String?>(nil)
    var contentUrl = Variable<String?>(nil)
    var imageUrl = Variable<String?>(nil)
    var unread = Variable<Bool>(true)
    
    private let entry: FeedEntry
    private let dateProvider = DateProviderImpl()
    
    init(entry: FeedEntry) {
        self.entry = entry
        title.value = entry.title
        content.value = entry.content
        date.value = dateProvider.parse(entry.createdAt)
        iconName.value = icon()
        videoUrl.value = entry.videoUrl
        contentUrl.value = entry.contentUrl
        imageUrl.value = entry.imageUrl
    }
    
    private func icon() -> String {
        if entry.videoUrl != nil {
            return "VideoWhite"
        }
        if entry.imageUrl != nil {
            return "ImageWhite"
        }
        if entry.contentUrl != nil {
            return "DocumentWhite"
        }
        return "InfoWhite"
    }
    
}
