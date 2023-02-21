//
//  LoginState+CoreDataProperties.swift
//  testApp
//
//  Created by Dmitry Telpov on 08.02.23.
//

import Foundation

import Foundation
import CoreData


extension LoginState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginState> {
        return NSFetchRequest<LoginState>(entityName: "LoginState")
    }

    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var userEmail: String?

}

extension LoginState : Identifiable {
    
}
