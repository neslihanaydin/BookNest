import SwiftUI

struct BookDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var book: Book // ObservedObject to monitor changes to the book
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Placeholder for Book Image
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 200, height: 300)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        .overlay(
                            Text("Book Cover")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        )
                        .padding(.top, 20)
                    
                    VStack(spacing: 8) {
                        Text(book.title ?? "Unknown Title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text("By \(book.author ?? "Unknown Author")")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text("Published in \(String(book.yearPublished))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut) {
                    book.isFavorite.toggle()
                    saveContext()
                }
            }) {
                HStack {
                    Image(systemName: book.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(book.isFavorite ? .red : .gray)
                        .font(.system(size: 28))
                    
                    Text(book.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                
            }
            .padding(.horizontal)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 10)
            }
        }
        .navigationTitle("Book Details")
    }
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleBook = Book(context: context)
    sampleBook.title = "Sample Book"
    sampleBook.author = "Sample Author"
    sampleBook.yearPublished = 2024
    sampleBook.isFavorite = false
    
    return BookDetailView(book: sampleBook)
        .environment(\.managedObjectContext, context)
}
