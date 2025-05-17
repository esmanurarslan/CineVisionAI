//
//  Data+Extensions.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
