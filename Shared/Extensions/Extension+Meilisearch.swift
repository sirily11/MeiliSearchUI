//
//  Extension+Meilisearch.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import Foundation
import MeiliSearch


//MARK: MeiliSearch
extension MeiliSearch {
    func getTasks() async throws -> [Task]{
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<[Task], FundationError>) in
            getTasks{ result in
                switch result {
                case .success(let results):
                    continuation.resume(returning: results.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func allStats() async throws -> AllStats{
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<AllStats, FundationError>) in
            allStats{ result in
                switch result {
                case .success(let indexes):
                    continuation.resume(returning: indexes)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /**
     Add new index
     */
    func createIndex(uid: String, primaryKey: String?) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            createIndex(uid: uid, primaryKey: primaryKey){ result in
                switch result {
                case .success(let indexes):
                    continuation.resume(returning: indexes)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /**
     Get settings by index
     */
    func waitForTask(task: Task) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            waitForTask(task: task) { result in
                switch result {
                case .success(let result):
                    if let error = result.error {
                        continuation.resume(throwing: MeilisearchError.taskFailed(type: error.type, reason: error.message))
                    } else {
                        continuation.resume(returning: result)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
    /**
     Update an index
     */
    func updateIndex(uid: String, primaryKey: String) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            updateIndex(uid: uid, primaryKey: primaryKey){ result in
                switch result {
                case .success(let indexes):
                    continuation.resume(returning: indexes)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /**
     Delete an index
     */
    func deleteIndex(uid: String) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            deleteIndex(uid){ result in
                switch result {
                case .success(let indexes):
                    continuation.resume(returning: indexes)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /**
     Get all indexes
     */
    func getIndexes() async throws -> [Index] {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<[Index], FundationError>) in
            getIndexes{ result in
                switch result {
                case .success(let indexes):
                    continuation.resume(returning: indexes)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /**
     Get index by id
     */
    func getIndex(_ uid: String) async throws -> Index {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Index, FundationError>) in
            getIndex(uid) { result in
                switch result {
                case .success(let index):
                    continuation.resume(returning: index)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

//MARK: Indexes
extension Indexes {
    func getTasks() async throws -> [Task]{
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<[Task], FundationError>) in
            getTasks{ result in
                switch result {
                case .success(let results):
                    continuation.resume(returning: results.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func search(_ keyword: SearchParameters) async throws -> SearchResult<Document>{
        typealias MeiliResult = Result<SearchResult<Document>, Swift.Error>
        
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<SearchResult<Document>, FundationError>) in
            search(keyword){ (result: MeiliResult) in
                switch result {
                case .success(let results):
                    continuation.resume(returning: results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /**
     Update index's setting
     */
    func updateSettings(settings: Setting) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            updateSettings(settings) { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
    
    /**
     Update index
     */
    func update(primaryKey: String) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            update(primaryKey: primaryKey) { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
    /**
     Get settings by index
     */
    func getSettings() async throws -> SettingResult {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<SettingResult, FundationError>) in
            getSettings { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
    /**
     Get stats by index
     */
    func stats() async throws -> Stat {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Stat, FundationError>) in
            stats { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
    /**
     Add documents
     */
    func addDocument(data: Data) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            addDocuments(documents: data) { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
    /**
     Get documents
     */
    func getDocuments(options: GetParameters) async throws -> [Document] {
        typealias MeiliResult = Result<[Document], Swift.Error>
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<[Document], FundationError>) in
            getDocuments(options: options){ (result: MeiliResult) in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /**
     Add documents
     */
    func deleteDocument(primaryKey: String) async throws -> Task {
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<Task, FundationError>) in
            deleteDocument(primaryKey) { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
    
}

// MARK: SettingResult
extension SettingResult {
    /**
     Get settings object from setting result
     */
    var settings: Setting {
        get {
            return Setting(rankingRules: rankingRules, searchableAttributes: searchableAttributes, displayedAttributes: displayedAttributes, stopWords: stopWords, synonyms: synonyms, distinctAttribute: distinctAttribute, filterableAttributes: filterableAttributes, sortableAttributes: sortableAttributes)
        }
    }
}


//MARK: Task
extension Task {
    
    static func createTestData() -> Task{
        let testData: [String: Any] = [
            "uid": 0,
            "indexUid": "movies",
            "status": "succeeded",
            "type": "documentAddition",
            "details": [
                "receivedDocuments": Int.random(in: 1..<100),
                "indexedDocuments":  Int.random(in: 1..<100)
            ],
            "duration": "PT16S",
            "enqueuedAt": "2021-08-11T09:25:53.000000Z",
            "startedAt": "2021-08-11T10:03:00.000000Z",
            "finishedAt": "2021-08-11T10:03:16.000000Z"
            
        ]
        let data = try! JSONSerialization.data(withJSONObject: testData)
        
        return try! JSONDecoder().decode(Task.self, from: data)
    }
    
    var percentage: Double? {
        get {
            if let details = details {
                if let received = details.receivedDocuments {
                    if let indexed = details.indexedDocuments {
                        return Double(indexed / received)
                    }
                }
            }
            
            return nil
        }
    }
    
    var percentageDescription: String? {
        get {
            if let details = details {
                if let received = details.receivedDocuments {
                    if let indexed = details.indexedDocuments {
                        return "\(indexed)/\(received)"
                    }
                }
                if let deleted = details.deletedDocuments  {
                    return "\(deleted)"
                }
            }
            
            return nil
        }
    }
}


extension Task.Status{
    
    var stringValue: String {
        get {
            switch self {
            case .enqueued:
                return "enqueued"
            case .failed:
                return "failed"
            case .succeeded:
                return "succeed"
            case .processing:
                return "processing"
            }
        }
    }
    
}

extension Stat {
    var columns: [DocumentColumn] {
        get {
            fieldDistribution.map { (key: String, value: Int) in
                DocumentColumn(name: key, value: value)
            }
        }
    }
}
