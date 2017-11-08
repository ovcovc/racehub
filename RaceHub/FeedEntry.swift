//
//  FeedEntry.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 16.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

class FeedEntry {
    var title = "title"
    var content = "content"
    var videoUrl: String?
    var imageUrl: String?
    var contentUrl: String?
    var createdAt = Date()
    var eventId = -1
    var distanceId = -1
}
