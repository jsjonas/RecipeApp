//
//  RecipesViewModel.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import Foundation
import Combine
import SwiftData

@Observable
class ViewModel {
    /// Singleton instance of the WebProvider for fetching data from the network.
    private let provider = WebProvider.shared

    /// Set to hold AnyCancellable instances for Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()

    /// Recipes data managed by this ViewModel.
    internal var recipesArray: RecipeArray

    /// Initializes a ViewModel with optional dependency injection.
    /// - Parameters:
    ///   - cancellables: Combine cancellables set for managing subscriptions.
    ///   - recipesArray: Initial value for the array of recipes.
    init(cancellables: Set<AnyCancellable> = Set<AnyCancellable>(), recipesArray: RecipeArray = RecipeArray()) {
        self.cancellables = cancellables
        self.recipesArray = recipesArray
    }
    /// Fetch data and insert it into the item's array
    func fetchData() -> Void {
        guard let recipesURL = UrlPath.recipesUrl else { return }
        self.provider.fetchRecipes(path: recipesURL)
            /// Ensure that updates are received on the main thread
            .receive(on: DispatchQueue.main)
            /// Handle completion and value reception
            .sink(receiveCompletion: { val in
                switch val {
                case .finished:
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                }
                
            }, receiveValue: { response in
                self.recipesArray = response
            })
            /// Store the subscription in the cancellables set
            .store(in: &self.cancellables)
    }

}
