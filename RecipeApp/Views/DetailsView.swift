//
//  DetailsView.swift
//  RecipeApp
//
//  Created by Jonas S on 21/11/2024.
//

import SwiftUI

struct DetailsView: View {
    let recipe: Recipe
    var body: some View {
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

#if DEBUG
#Preview {
    let recipeString = "There\\u2019s nothing like the simple things in life - the smell of freshly cut grass, sitting outside on a nice sunny day, spending time with friends and family. Well here is a recipe that delivers simple culinary pleasures - some nice fresh fish with a crispy crust, crunchy potato wedges and some delightfully sweet sugar snap peas flavoured with cooling mint. Slip into something comfortable and relax into a delicious dinner!"
    let recipe = Recipe(calories: "516 kcal",
                        carbos: "47 g",
                        description: recipeString.decodingUnicodeCharacters,
                        difficulty: 0,
                        fats: "8 g",
                        headline: "with Sweet Potato Wedges and Minted Snap Peas",
                        id: "533143aaff604d567f8b4571",
                        image: "https://img.hellofresh.com/f_auto,q_auto/hellofresh_s3/image/533143aaff604d567f8b4571.jpg",
                        name: "Crispy Fish Goujons",
                        proteins: "43 g",
                        thumb: "https://img.hellofresh.com/f_auto,q_auto,w_300/hellofresh_s3/image/533143aaff604d567f8b4571.jpg",
                        time: "PT35M")
    DetailsView(recipe: recipe)
}
#endif

extension String {
    var decodingUnicodeCharacters: String { applyingTransform(.init("Hex-Any"), reverse: false) ?? "" }
}
