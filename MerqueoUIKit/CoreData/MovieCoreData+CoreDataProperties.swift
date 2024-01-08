//
//  MovieCoreData+CoreDataProperties.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 8/01/24.
//
//

import Foundation
import CoreData


extension MovieCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreData> {
        return NSFetchRequest<MovieCoreData>(entityName: "MovieCoreData")
    }

    @NSManaged public var movieCast: String?
    @NSManaged public var movieDescription: String?
    @NSManaged public var movieDirector: String?
    @NSManaged public var movieImage: String?
    @NSManaged public var movieTitle: String?
    @NSManaged public var movieYear: String?

}

extension MovieCoreData : Identifiable {

}
