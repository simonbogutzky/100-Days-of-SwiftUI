//
//  Friend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Simon Bogutzky on 18.11.20.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var user: User?
    
    var wrappedName: String {
        return name != nil ? name! : "Unknown"
    }
}

extension Friend : Identifiable {

}
