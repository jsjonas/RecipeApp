//
//  WebProvider.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import Foundation
import Combine
import UIKit

class WebProvider {
    static let shared: WebProvider = WebProvider()
    
    func fetchRecipes(path: URL = UrlPath.recipesUrl!) -> AnyPublisher<RecipeArray, Error> {
        var request = URLRequest(url: path)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept": "application/json"
        ]
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: RecipeArray.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

enum UrlPath {
    static let recipesUrl = URL(string: "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json")
}
