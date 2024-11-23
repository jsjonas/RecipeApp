//
//  Recipe.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import Foundation

// MARK: - RecipeElement
struct Recipe: Codable, Identifiable, Hashable {
    let calories, carbos, description: String
    let difficulty: Int
    let fats, headline, id: String
    let image: String
    let name, proteins: String
    let thumb: String
    let time: String
}

typealias RecipeArray = [Recipe]
