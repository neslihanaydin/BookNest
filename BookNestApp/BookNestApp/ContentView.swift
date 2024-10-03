//
//  ContentView.swift
//  BookNestApp
//
//  Created by Neslihan Turpcu on 2024-10-02.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var searchText = ""
    @State private var searchCategory: SearchCategory = .title
    @State private var sortOption: SortOption = .title
    
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case author = "Author"
        case yearPublished = "Year Published"
    }
    
    enum SearchCategory: String, CaseIterable {
        case title = "Title"
        case author = "Author"
    }
    
    @FetchRequest var books: FetchedResults<Book>
    
    init() {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.title, ascending: true)]
        
        _books = FetchRequest(fetchRequest: request)
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
                HStack {
                    TextField("Search by \(searchCategory.rawValue.lowercased())", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("", selection: $searchCategory) {
                        ForEach(SearchCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                ForEach(filteredBooks(), id: \.self) { book in
                    NavigationLink {
                        HStack {
                            Text("Book at \(book.title!)")
                        }
                    } label: {
                        VStack {
                            Text(book.title!)
                                .font(.title2)
                            Text(book.author!)
                                .font(.footnote)
                        }
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            // .searchable(text: $searchText, prompt: "search...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink {
                        AddBookView()
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
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
    private func filteredBooks() -> [Book] {
        /*
         With this approach, the fetch request is made again, and it does not retrieve the updated data when returning to the main page after adding a new book. Therefore, using the .filter method is more efficient.
         
         let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
         fetchRequest.predicate = buildPredicate()
         fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Book.title, ascending: true)]
         
         do {
         return try viewContext.fetch(fetchRequest)
         } catch {
         print("Books Fetch Failed: \(error.localizedDescription)")
         return []
         }
         */
        let filtered = searchText.isEmpty ? Array(books) : books.filter { book in
            switch searchCategory {
            case .title:
                return book.title?.localizedCaseInsensitiveContains(searchText) ?? false
            case .author:
                return book.author?.localizedCaseInsensitiveContains(searchText) ?? false
            }
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
    private func buildPredicate() -> NSPredicate {
        if searchText == "" {
            return NSPredicate(value: true)
        } else {
            switch searchCategory {
            case .title:
                return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            case .author:
                return NSPredicate(format: "author CONTAINS[cd] %@", searchText)
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
