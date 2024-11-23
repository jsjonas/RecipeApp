//
//  ContentView.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import SwiftUI

struct RecipesListView: View {
    /// ViewModel handle logic and data
    @State var viewModel: RecipesListViewModel
    @State private var selection: String? = nil

    var body: some View {
        NavigationStack {
            List(self.viewModel.recipesArray) { item in
                ZStack(alignment: .leading) {
                    NavigationLink(
                        destination: RecipeDetailsView(),
                        tag: item.id,
                        selection: $selection
                    ) { EmptyView() }

                    Button(action: {
                        self.viewModel.storeItem(item: item, completion: { id in
                            self.selection = id
                        })
                    }, label: {
                        RecipeView(recipe: item)
                    })

                }
            }
            .navigationTitle("Recipes")
        }
        .environment(viewModel)
        /// Displays a ProgressView if the list of recipes is empty
        .overlay {
            if viewModel.recipesArray.isEmpty {
                ProgressView()
            }
        }
        /// Asynchronous task to fetch data if the list is empty
        .task {
            if viewModel.recipesArray.isEmpty {
                self.viewModel.fetchData()
            }
        }
        /// Enables pull-to-refresh to fetch data
        .refreshable {
            self.viewModel.fetchData()
        }
    }
}

struct RecipeView: View {
    var recipe: Recipe
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name :\(recipe.name)")
            Text("Thumbs :\(recipe.fats)")
            Text("Fats :\(recipe.fats)")
            Text("Calories: \(recipe.calories)")
            Text("Carbos: \(recipe.carbos)")
        }
    }
}

#Preview {
    RecipesListView(viewModel: RecipesListViewModel())
}
