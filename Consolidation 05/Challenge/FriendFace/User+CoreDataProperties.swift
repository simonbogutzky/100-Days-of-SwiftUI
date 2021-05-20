//
//  User+CoreDataProperties.swift
//  FriendFace
//
//  Created by Simon Bogutzky on 18.11.20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var company: String?
    @NSManaged public var address: String?
    @NSManaged public var friends: NSSet?
    
    var wrappedName: String {
        return name != nil ? name! : "Unknown"
    }
    
    var wrappedEmail: String {
        return email != nil ? email! : "Unknown"
    }
    
    var wrappedAddress: String {
        return address != nil ? address! : "Unknown"
    }
    
    var wrappedCompany: String {
        return company != nil ? company! : "Unknown"
    }
    
    public var friendArray: [Friend] {
        let set = friends as? Set<Friend> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User : Identifiable {

}
