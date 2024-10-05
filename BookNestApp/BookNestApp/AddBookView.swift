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
    
    // Field Validation
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add a New Book")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Form {
                TextField("Book Title", text: $bookTitle)
                TextField("Book Author", text: $bookAuthor)
                TextField("Publish Year", text: $yearPublished)
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal, 16)
            
            // Show Error
            if showError {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .shadow(color: Color.red.opacity(0.5), radius: 4, x: 0, y: 2)
            }
            
            Button(action: {
                if validateFields() {
                    addBook()
                }
            }) {
                Text("Submit")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
            }
            
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func validateFields() -> Bool {
        if bookTitle.isEmpty {
            showError = true
            errorMessage = "Book title cannot be empty."
            return false
        }
        
        if bookAuthor.isEmpty {
            showError = true
            errorMessage = "Book author cannot be empty."
            return false
        }
        
        if yearPublished.isEmpty || Int(yearPublished) == nil {
            showError = true
            errorMessage = "Publish year must be a valid number."
            return false
        }
        
        showError = false
        return true
    }
    
    private func addBook() {
        let newBook = Book(context: viewContext)
        newBook.author = bookAuthor
        newBook.title = bookTitle
        newBook.isFavorite = false
        newBook.yearPublished = Int16(yearPublished) ?? 0
        do {
            try viewContext.save()
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
