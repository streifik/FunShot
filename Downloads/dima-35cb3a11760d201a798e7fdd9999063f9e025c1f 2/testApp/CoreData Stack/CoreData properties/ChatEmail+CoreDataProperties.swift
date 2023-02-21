//
//  ChatEmail+CoreDataProperties.swift
//  teatApp
//
//  Created by streifik on 22.12.2022.
//
//

import Foundation
import CoreData


extension ChatEmail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatEmail> {
        return NSFetchRequest<ChatEmail>(entityName: "ChatEmail")
    }

    @NSManaged public var email: String?
    @NSManaged public var chat: Chat?

}

extension ChatEmail : Identifiable {

}
