//
//  MeilisearchError.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import Foundation

typealias FundationError = Error

enum MeilisearchError: Error {
    case unableToFetchIndexes;
}
