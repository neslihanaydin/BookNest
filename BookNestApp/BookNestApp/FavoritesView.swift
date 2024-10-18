//
//  FavoritesView.swift
//  BookNestApp
//
//  Created by Neslihan Turpcu on 2024-10-05.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)],
        predicate: NSPredicate(format: "isFavorite == true"))
    private var favBooks: FetchedResults<Book>
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favBooks) { book in
                    NavigationLink {
                        //Text("Favorite Book of \(book.author!)")
                        BookDetailView(book: book)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .truncationMode(.tail)
                            
                            Text(book.author ?? "Unknown Author")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: updateItems)
            }
        }
        .navigationTitle("Favorite Books")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                NavigationLink {
                    AddBookView()
                        .environment(\.managedObjectContext, viewContext)
                } label : {
                    Label("Add Book", systemImage: "plus")
                }
            }
        }
        
    }
    
    private func updateItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { favBooks[$0] }.forEach { book in
                book.isFavorite = false
            }
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    FavoritesView()
}
