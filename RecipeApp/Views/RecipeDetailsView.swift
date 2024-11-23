//
//  DetailsView.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
    @State var recipeState: ResultState<Recipe, Error>? = .loading(nil)
    @Environment(RecipesListViewModel.self) var viewModel

    var body: some View {
        switch recipeState {
        case .waiting:
            ProgressView()
        case .loading(_):
            ProgressView()
                .onAppear {
                    self.recipeState = .waiting
                    self.viewModel.retrieveItem(completion: { recipe in
                        guard let recipe = recipe else {
                            self.recipeState = .failed(RecipeError())
                            return
                        }
                        self.recipeState = .found(recipe)
                    })
                }
        case .found(let recipe):
            VStack(spacing: 20) {
                RecipeImage(recipe: recipe)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name :\(recipe.name)")
                        Text("Fats :\(recipe.fats)")
                        Text("Calories: \(recipe.calories)")
                        Text("Carbos: \(recipe.carbos)")
                    }
                }
                
                Text(recipe.description)
                    .padding(.horizontal, 25)
            }
        case .failed(let e):
            // TODO: Implement Error View
            EmptyView()
        case .none:
            EmptyView()
        }
    }
}

struct RecipeImage: View {
    let recipe: Recipe
    var body: some View {
        AsyncImage(url: URL(string: recipe.image)) { imagePhase in
            switch imagePhase {
            case .empty:
                Image(systemName: "ellipsis")
            case .success(let returnedImage):
                returnedImage
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "xmark.circle")
                    .font(.headline)
                    .foregroundColor(.red)
            @unknown default:
                Image(systemName: "ellipsis")
            }
        }
    }
}
enum ResultState<T, E: Error> {
    case waiting
    case loading(T?)
    case found(T)
    case failed(E)
}

struct RecipeError: Error {}
