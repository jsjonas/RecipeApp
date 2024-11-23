//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import SwiftUI

@main
struct RecipeAppApp: App {
    var body: some Scene {
        WindowGroup {
            RecipesListView(viewModel: RecipesListViewModel())
        }
    }
}
