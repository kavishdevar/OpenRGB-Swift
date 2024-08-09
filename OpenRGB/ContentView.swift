//
//  ContentView.swift
//  OpenRGB
//
//  Created by Kavish Devar on 09/08/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selection: Item?
    var body: some View {
        NavigationSplitView {
            List (selection: $selection) {
                ForEach(items) { item in
                    NavigationLink {
                        Text(item.ip)
                    } label: {
                        Text(item.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: {deleteItem()}) {
                        Label("Delete", systemImage: "bin")
                    }
                }
                ToolbarItem {
                    Button(action: {addItem(ip: "192.168.1.90", name: "BigBox")}) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem(ip: String, name: String = "") {
        var name_: String
        
        if name == "" {
            name_ = ip
        }
        else {
            name_ = name
        }
        withAnimation {
            let newItem = Item(ip: ip, name: name_)
            modelContext.insert(newItem)
        }
    }

    private func deleteItem() {
        withAnimation {
            modelContext.delete(items.firstIndex(of: selection))
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
