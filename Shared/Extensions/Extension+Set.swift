//
//  Extension+Set.swift
//  meilisearch
//
//  Created by Qiwei Li on 7/6/22.
//

import Foundation


extension Set where Element: Hashable {
    func firstIndex(of target: Element) -> Int? {
        var index = 0
        for ele in self{
            if ele == target {
                return index
            }
            index  += 1
        }
        
        return nil
    }
}
