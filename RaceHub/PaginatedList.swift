//
//  PaginatedList.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 18.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation

public struct PaginatedList<T> {
    
    // MARK: - Properties
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [T]
    
    // MARK: - Initializer
    
    init(page: Int, totalResults: Int, totalPages: Int, results: [T]) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }
    
    // MARK: - Helper functions / properties
    
    var count: Int { return self.results.count }
    
    var nextPage: Int? {
        let nextPage = self.page + 1
        guard nextPage < self.totalPages else { return nil }
        return nextPage
    }
    
    static func Empty() -> PaginatedList { return PaginatedList(page: 0, totalResults: 0, totalPages: 0, results: []) }
}

extension PaginatedList {
    
    // MARK: - Subscript
    
    subscript(index: Int) -> T {
        return self.results[index]
    }
}
