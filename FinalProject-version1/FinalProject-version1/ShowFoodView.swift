//
//  ShowFoodView.swift
//  FinalProject-version1
//
//  Created by Bao Huynh on 4/5/23.
//

import SwiftUI
import CoreData


struct ShowFoodView: View {
    
    // VARIABLES
    let APIKey = "dc207e21d7af4419ae84b18b302cce90"
    @State var recipe: Recipe?
    @State var foodName: String
    @State var foodSummary: String
    @State var imageLink: String
    @State var foodID: Int64
    
    var addNewFood: (String, String, String, Int64) -> ()

    //Jsondata Object
    @State var jsonData = FoodData(results: [])
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        Button("<< Back to Home", role: .cancel, action: {
            self.presentationMode.wrappedValue.dismiss()
        }) .padding(10)
        
        HStack {
            Spacer()
            TextField("What food do you want to make?", text: $foodName)
            Button("Search", action: {
                loadJsonData()
            })
            Spacer()
            Spacer()
        } .padding(10)
        
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(jsonData.results, id: \.id) { result in
                        NavigationLink(destination: VStack {
                            HStack {
                                AsyncImage(url: URL(string: result.image)) { image in
                                    image
                                        .resizable()
                                        .frame(width: 150, height: 80)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                Button("Save \n Recipe?", action: {
                                    addNewFood(result.title, foodSummary, result.image, result.id)
                                })
                            }
                            Text("\(result.title)")
                                .font(.title)
                            
                            Text("\(foodSummary)")
                                .padding(10)
                            Spacer()
                        }
                            .onAppear() {
                                fetchRecipe(foodID: String(result.id))
                            }
                        ) {
                            HStack {
                                VStack {
                                    Text("\(result.title)")
                                        .font(.headline)
                                }
                                Spacer()
                                AsyncImage(url: URL(string: result.image)) { image in
                                    image
                                        .resizable()
                                        .frame(width: 150, height: 80)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
    
    //******************* API CALL DATA I *******************//
    func loadJsonData() {
        let full_URL = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(APIKey)&query=\(foodName)"
        
        let url = URL(string: full_URL)!
        let url_session = URLSession.shared
        let JSON_query = url_session.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            var err: NSError?
            
            do {
                let decodedData = try JSONDecoder().decode(FoodData.self, from: data!)
                
                // TESTING PART
//                print(decodedData)
                self.jsonData = decodedData
//                print("JSON \(jsonData)")
            } catch {
                print("error: \(error)")
            }
        })
        JSON_query.resume()
    }
    
    
    //******************* API CALL DATA II *******************//
    func fetchRecipe(foodID: String) {
        let id = foodID
        if let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/information?apiKey=\(APIKey)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let recipe = try decoder.decode(Recipe.self, from: data)
                        DispatchQueue.main.async {
                            self.recipe = recipe
                            
                            if let htmlString = recipe.summary.data(using: .utf8) {
                                do {
                                    let attributedString = try NSAttributedString(data: htmlString, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                                    self.foodSummary = attributedString.string
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    }
    
}



