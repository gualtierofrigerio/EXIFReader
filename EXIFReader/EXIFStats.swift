//
//  ExifStats.swift
//  EXIFReader
//
//  Created by Gualtiero Frigerio on 25/10/2020.
//

import Foundation

struct EXIFRecord {
    var key:String
    var count:Int
    var percentage:String
}

struct EXIFStats {
    var numberOfRecords:Int {
        records.keys.count
    }
    var sortedRecords:[EXIFRecord] {
        getSortedRecords()
    }
    var records:[String:Int] = [:]
    
    mutating func updateWithValue(_ value:String) {
        if let currentValue = records[value] {
            records[value] = currentValue + 1
        }
        else {
            records[value] = 1
        }
    }
    
    private func getSortedRecords() -> [EXIFRecord] {
        var sortedArray:[EXIFRecord] = []
        let totalCount = records.values.reduce(0) { (x, y) in
            x + y
        }
        for (key, value) in records {
            let percentage = Float(value) / Float(totalCount) * 100
            let percentageStr = String(format: "%2.f %%", percentage)
            sortedArray.append(EXIFRecord(key: key, count: value, percentage: percentageStr))
        }
        sortedArray.sort { (a, b) -> Bool in
            a.count > b.count
        }
        return sortedArray
    }
}
