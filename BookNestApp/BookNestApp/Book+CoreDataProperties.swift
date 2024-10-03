//
//  Book+CoreDataProperties.swift
//  BookNestApp
//
//  Created by Neslihan Turpcu on 2024-10-02.
//
//

import Foundation
import CoreData


extension Book: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var yearPublished: Int16
    @NSManaged public var isFavorite: Bool

}
