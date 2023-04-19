//
//  DataModel.swift
//  FinalProject-version1
//
//  Created by Bao Huynh on 4/13/23.
//

import SwiftUI
import Foundation
import CoreData

struct FoodData: Decodable {
    let results: [result]
}

struct result: Decodable {
    let id: Int64
    let title: String
    let image: String
    let imageType: String
}

struct Recipe: Codable {
    let id: Int
    let title: String
    let summary: String
}
