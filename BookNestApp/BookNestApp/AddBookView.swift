//
//  AddBookView.swift
//  BookNestApp
//
//  Created by Neslihan Turpcu on 2024-10-02.
//

import SwiftUI
import CoreData

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
  
    
    @State var bookTitle: String = ""
    @State var bookAuthor: String = ""
    @State var yearPublished: String = ""
    var body: some View {
        VStack {
            Form {
                TextField("Book Title", text: $bookTitle)
                    .padding([.top, .bottom], 10)
                TextField("Book Author", text: $bookAuthor)
                    .padding([.top, .bottom], 10)
                TextField("Publish Year", text: $yearPublished)
                    .padding([.top, .bottom], 10)
            }
            .padding()
            Spacer()
            Button {
                addBook()
            } label: {
                Text("Submit")
            }
            Spacer()
        }
    }
    
    private func addBook() {
        let newBook = Book(context: viewContext)
        newBook.author = bookAuthor
        newBook.title = bookTitle
        newBook.yearPublished = Int16(yearPublished) ?? 0
        
        do {
            try viewContext.save()
            
            // dismiss the view
            dismiss()
        } catch  {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        
    }
}

#Preview {
    AddBookView()
}
