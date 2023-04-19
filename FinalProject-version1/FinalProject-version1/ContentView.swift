//
//  ContentView.swift
//  FinalProject-version1
//  Created by Bao Huynh on 3/30/23.
// API Key 1: f0ed2683b6b04d4bb5b89763706d9926
// API Key 2 (Bao2126828): dc207e21d7af4419ae84b18b302cce90
//

import SwiftUI
import CoreData


//******************** MAIN VIEW ********************//
struct ContentView: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var showfoodView = false
    
    @State var mapView = false
    @State var cityName: String    
    var dataModel = DataModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Button("Search New Meal?", action: {
                self.showfoodView = true
            })
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showfoodView) {
                ShowFoodView(foodName: "", foodSummary: "", imageLink: "", foodID: 0, addNewFood: dataModel.addItem)
            }
            Spacer()
            Spacer()
        }
                
        Text("Your Meal History")
            .font(.title)
  
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: VStack {
                        HStack {
                            AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                                image
                                    .resizable()
                                    .frame(width: 150, height: 80)
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                                                
                        Text(item.title ?? "")
                            .font(.title2)
                        
                        Text(item.summary ?? "")
                            .padding(10)
                        Spacer()
                    }) {
                        HStack {
                            VStack {
                                Text(item.title ?? "")
                                    .font(.headline)
                            }
                            Spacer()
                            AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                                image
                                    .resizable()
                                    .frame(width: 150, height: 80)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                } .onDelete(perform: deleteItems)
            }
        }
                
        /** TRIGGER MAPVIEW **/
        HStack {
            Spacer()
            Spacer()
            
            TextField("Where do you live?", text: $cityName)
            Button("Map") {
                self.mapView = true
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $mapView) {
                MapView(city: cityName)
            }
            Spacer()
            Spacer()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cityName: "").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
