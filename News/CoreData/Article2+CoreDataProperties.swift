//
//  Article2+CoreDataProperties.swift
//  
//
//  Created by Bimo Sekti Wicaksono on 12/09/23.
//
//

import Foundation
import CoreData


extension Article2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article2> {
        return NSFetchRequest<Article2>(entityName: "Article2")
    }

    @NSManaged public var title: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var url: String?

}
