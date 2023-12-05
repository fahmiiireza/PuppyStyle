//
//  ContentView.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 05/12/23.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseFirestore // Import FirebaseFirestore


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    
    // Add Firestore reference
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func addItem() {
           withAnimation {
               let newItem = Item(timestamp: Date())
               modelContext.insert(newItem)

               // Add the item to Firestore
               db.collection("items").addDocument(data: [
                   "timestamp": "nfelix"
               ]) { err in
                   if let err = err {
                       print("Error adding document: \(err)")
                   } else {
                       print("Document added with ID: \(newItem.timestamp)")
                   }
               }
           }
       }

       private func deleteItems(offsets: IndexSet) {
           // ... your existing code
       }
   }

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
