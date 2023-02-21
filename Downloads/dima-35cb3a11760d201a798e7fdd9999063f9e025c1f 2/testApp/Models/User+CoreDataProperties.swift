//
//  User+CoreDataProperties.swift
//  teatApp
//
//  Created by streifik on 09.12.2022.
//
//

import Foundation
import CoreData


extension User {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int
    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var password: String
    @NSManaged public var phone: Int
    @NSManaged public var profileImage: Data?
    @NSManaged public var surname: String
    @NSManaged public var chats: [Chat]
}

extension User : Identifiable {
}
