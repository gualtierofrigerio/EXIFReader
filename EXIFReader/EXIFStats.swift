//
//  ExifStats.swift
//  EXIFReader
//
//  Created by Gualtiero Frigerio on 25/10/2020.
//

import Foundation

struct EXIFStats {
    var records:[String:Int] = [:]
    
    mutating func updateWithValue(_ value:String) {
        if let currentValue = records[value] {
            records[value] = currentValue + 1
        }
        else {
            records[value] = 1
        }
    }
}
