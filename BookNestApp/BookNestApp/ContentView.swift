//
//  ContentView.swift
//  BookNestPart1
//
//  Created by Neslihan Turpcu on 2024-10-03.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)],
        animation: .default)
    private var books: FetchedResults<Book>
    
    @State var searchText = ""
    
    @State private var sortOption: SortOption = .title
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case author = "Author"
        case yearPublished = "Year Published"
    }
    
    var body: some View {
            NavigationView {
                List {
                    Picker("Sort by", selection: $sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    ForEach(filterBooks()) { book in
                        NavigationLink {
                            //Text("Book of \(book.author!)")
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
                    .onDelete(perform: deleteItems)
                }
                .searchable(text: $searchText, prompt: "Search by title or author...")
                .navigationTitle("Books")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Book(context: viewContext)
            newItem.title = "Book \(books.count)"
            newItem.author = "Author \(books.count)"
            newItem.yearPublished = 2024
            newItem.isFavorite = false
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func filterBooks() -> [Book] {
        
        let filtered = searchText.isEmpty ? Array(books) : books.filter { book in
            let titleMatches = book.title?.localizedCaseInsensitiveContains(searchText) ?? false
            let authorMatches = book.author?.localizedCaseInsensitiveContains(searchText) ?? false
            return titleMatches || authorMatches
        }
        switch sortOption {
        case .title:
            return filtered.sorted { ($0.title ?? "") < ($1.title ?? "") }
        case .author:
            return filtered.sorted { ($0.author ?? "") < ($1.author ?? "") }
        case .yearPublished:
            return filtered.sorted { ($0.yearPublished) < ($1.yearPublished) }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
