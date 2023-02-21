
//
//  LoginState+CoreDataClass.swift
//  testApp
//
//  Created by Dmitry Telpov on 08.02.23.
//
//

import Foundation
import CoreData

@objc(LoginState)
public class LoginState: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(false, forKey: "isLoggedIn")
    }
}
