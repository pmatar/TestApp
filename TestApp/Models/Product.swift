//
//  Product.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Product: Codable {
    var id: Int
    let title: String
    let price: Double
    var description: String
    let category: String
    let image: URL
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
