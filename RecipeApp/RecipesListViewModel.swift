//
//  RecipesViewModel.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import Foundation
import Combine

@Observable
class RecipesListViewModel {

    /// Used to fetch data from remote APIs such as the recipes endpoint.
    private let provider = WebProvider.shared
    /// Used to store and retrieve sensitive data like recipe information.
    private let keychainProvider = KeychainManager.shared
    /// Used to manage biometric authentication such as Face ID or Touch ID for secure access.
    private let authProvider = BiometricAuthManager.shared

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

    /// Fetches data from the network and updates the recipes array.
    /// - Note: The network call uses Combine to handle asynchronous operations.
    ///         The result is received and processed on the main thread.
    func fetchData() -> Void {
        self.provider.fetchRecipes(path: UrlPath.recipesUrl)
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

    /// Stores a recipe item securely in the Keychain.
    /// - Parameters:
    ///   - item: The `Recipe` object to store.
    ///   - completion: A closure returning the recipe's ID if successful, or `nil` otherwise.
    func storeItem(item: Recipe, completion: @escaping (String?) -> Void) -> Void {
        if let data = try? DataCoder.encode(item) {
            self.keychainProvider.storeItemData(recipeData: data) { success in
                if success {
                    completion(item.id)
                } else {
                    completion(nil)
                }
            }
        }
        else { completion(nil) }
    }

    /// Retrieves a recipe item securely from the Keychain.
    /// - Parameter completion: A closure returning the retrieved `Recipe` object or `nil` if an error occurred.
    /// - Note: Uses biometric authentication to ensure secure access to the stored data.
    func retrieveItem(completion: @escaping (Recipe?) -> Void) -> Void {
        self.authProvider.authenticateWithBiometrics(completion: {
            success, context, error in
            
            if success {
                self.keychainProvider.retrieveItemData(context: context, completion: { recipeData, _, error in
                    guard let recipeData, let recipe = try? DataCoder.decode(Recipe.self, from: recipeData) else {
                        completion(nil)
                        return
                    }
                    completion(recipe)
                })
            }
            else { completion(nil) }
        })
    }
}

