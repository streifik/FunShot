//
//  Message1+CoreDataProperties.swift
//  teatApp
//
//  Created by streifik on 13.12.2022.
//
//

import Foundation
import CoreData


extension Message {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var chat: Chat?
    @NSManaged public var senderEmail: String?
    @NSManaged public var recieverEmail: String?
    @NSManaged public var senderName: String?
    @NSManaged public var recieverName: String?
}

extension Message : Identifiable {
}
