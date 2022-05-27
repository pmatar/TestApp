//
//  Product.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import Foundation

struct Product: Codable {
    
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: URL
    let rating: Rating
    
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
