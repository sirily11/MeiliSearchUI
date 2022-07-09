//
//  Document.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import Foundation
import SwiftyJSON

//public struct AnyCodable: Codable {
//    let value: Any
//
//    public init(_ value: Any) {
//        self.value = value
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//
//        if let value = try? container.decode(Int.self) {
//            self.value = value
//            return
//        }
//
//        if let value = try? container.decode(Double.self) {
//            self.value = value
//            return
//        }
//
//        if let value = try? container.decode(String.self) {
//            self.value = value
//            return
//        }
//
//        if let value = try? container.decode(Bool.self) {
//            self.value = value
//            return
//        }
//
//        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AnyCodable type")
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//
//        if let value = value as? Int {
//            try container.encode(value)
//            return
//        }
//
//        if let value = value as? Double {
//            try container.encode(value)
//            return
//        }
//
//        if let value = value as? String {
//            try container.encode(value)
//            return
//        }
//
//        if let value = value as? Bool {
//            try container.encode(value)
//            return
//        }
//
//        throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Invalid type"))
//    }
//}

struct DocumentColumn : Codable, Identifiable, Equatable{
    var id = UUID()
    let name: String
    let value: Int
}


struct Document: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    var value: JSON
    
    
    init(value: JSON) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(JSON.self) {
            self.value = value
            return
        }
        
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AnyCodable type")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
    static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
