//
//  Tests_BsonDecoding.swift
//  Tests macOS
//
//  Created by Qiwei Li on 7/7/22.
//

import XCTest
@testable import MeiliSearchUI

class Tests_BsonDecoding: XCTestCase {
    struct TestStruct: Codable {
        var name: String
        var data: Document
    }
    
    func testDecoding() throws {
        
        let data = """
               {
                  "name":"test",
                  "data":{
                     "age":1,
                     "sex":"m"
                  }
               }
               """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(TestStruct.self, from: data)

        XCTAssertEqual(decoded.data.value["age"].int!, 1)
        XCTAssertEqual(decoded.data.value["sex"].string!, "m")
        
        let jsonString = decoded.data.value.rawString()
        
        XCTAssertGreaterThan(jsonString!.count, 1)
       
    }

}
