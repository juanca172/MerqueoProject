//
//  Movie+CoreDataProperties.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 26/12/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var movieTitle: String?
    @NSManaged public var movieYear: String?
    @NSManaged public var movieImage: String?
    @NSManaged public var movieDirector: String?
    @NSManaged public var movieDescription: String?
    @NSManaged public var movieCast: String?

}

extension Movie : Identifiable {

}
