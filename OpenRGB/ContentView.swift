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
    
    @State var ip: String = "192.168.1."
    @State var name: String = ""
    @State var port: String = "6472"
    
    @State var adding: Bool = false

    var body: some View {
        NavigationSplitView {
            List (selection: $selection) {
                ForEach(items) { item in
                    NavigationLink {
                        Text(item.ip)
                    } label: {
                        Text(item.name)
                    }.swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            modelContext.delete(item)
                        }
                    }
                    .contextMenu {
                        Button {
                            modelContext.delete(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
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
                    Button(action: {adding=true}, label: {Label("Add Item", systemImage: "plus")} )
                    .confirmationDialog("Add Item", isPresented: $adding) {
                        TextField("IP", text: $ip)
                        TextField("Name", text: $name)
                        TextField("Port", text: $port)
                        Button("OK", action: addItem)
                        Button("Cancel", role: .cancel) { }
                    }
                    message: {
                        Text("Enter server details.")
                    }
                }
            }
        } detail: {
            Text("Welcome! Select a server")
        }
    }

    private func addItem() {
        name = $name.wrappedValue
        ip = $ip.wrappedValue
        port = $port.wrappedValue
        
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

    private func deleteItem(toDelete: Item) {
        withAnimation {
            modelContext.delete(toDelete)
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
