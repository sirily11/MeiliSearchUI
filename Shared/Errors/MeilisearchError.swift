//
//  MeilisearchError.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import Foundation

typealias FundationError = Error

enum MeilisearchError: Error, LocalizedError {
    case unableToFetchIndexes;
    case taskFailed(type: String, reason: String)
    
    
    var errorDescription: String? {
        switch self {
        case .unableToFetchIndexes: return "Unable to fetch indexes"
        case .taskFailed(let type, let reason): return "\(type): \(reason)"
        }
    }
    
}
