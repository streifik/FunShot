//
//  Chat+CoreDataProperties.swift
//  teatApp
//
//  Created by streifik on 13.12.2022.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var userName: String?
    @NSManaged public var userEmail: String?
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastMessageDate: Date?
    @NSManaged public var messages: Set<Message>
    @NSManaged public var user: User?
    @NSManaged public var chatEmails: Set<ChatEmail>
}



extension Chat : Identifiable {

}
