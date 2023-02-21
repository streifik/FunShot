//
//  CoreDataManager.swift
//  testApp
//
//  Created by Dmitry Telpov on 11.01.23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
  static let shared = CoreDataManager()
    
     var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "testApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Fetch Users Data
    
    func fetchUsersData() -> [User]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results = try context.fetch(fetchRequest)
            if let users = results as? [User] {
                return users
            }
        } catch {
            print("error")
        }
        return nil
    }
    
    // MARK: Fetch User Data
    
    func fetchUserData(userEmail: String) -> User? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", userEmail)
        
        do {
            let results = try context.fetch(fetchRequest)
                if let user = results.first as? User {
                    return user
                }
            } catch {
                print("error")
            }
            return nil
        }
    
    // MARK: Fetch Chats
    
    func fetchChats(userEmail: String) -> [Chat]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate1 = NSPredicate(format: "firstEmail == %@", "\(userEmail)")
        let predicate2 = NSPredicate(format: "secondEmail == %@", "\(userEmail)")
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
        do {
            let results = try context.fetch(fetchRequest)
            if let chats = results as? [Chat] {
                return chats
            }
        } catch {
            print("Error")
        }
        return nil
    }
    
    // MARK: Add User
    
    func addUser(name: String, surname: String, email: String, phone: Int, password: String, age: Int, profileImage: UIImage) -> User? {
        let context = persistentContainer.viewContext
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.name = name
            user.surname = surname
            user.email = email
            user.phone = phone
            user.password = password
            user.age = age
            user.profileImage = profileImage.pngData()
           
            do {
                try context.save()
            } catch {
                print("Error with context save")
            }
            return user
            }
            return nil
        }
    
    // MARK: Add Chat
    
    func addChat() -> Chat? {
        let context = persistentContainer.viewContext
        let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as! Chat
        
        return chat
    }
    
    // MARK: Add Message
    
    func addMessage(image: UIImage?, senderName: String, recieverName: String, senderEmail: String, recieverEmail: String, text: String?, date : Date, chat: Chat) -> Message? {
        let context = persistentContainer.viewContext
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
         
         message.senderName = senderName
         message.recieverName = recieverName
         message.senderEmail = senderEmail
         message.recieverEmail = recieverEmail
         message.text = text
         message.chat = chat
         message.date = date
         
        if let image = image {
            message.image = image.pngData()
        }
    
        
        do {
            try context.save()
        } catch {
            print("Error with context save")
        }
        
         return message
    }
    
    // MARK: Set Login state
    
    func setLoginState(isLoggedIn: Bool, userEmail: String?) -> LoginState? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginState")
        do {
            let results = try context.fetch(fetchRequest)
            if results.count == 0 {
                if let loginState = NSEntityDescription.insertNewObject(forEntityName: "LoginState", into: context) as? LoginState {
                    loginState.isLoggedIn = isLoggedIn
                    loginState.userEmail = userEmail
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error with context save")
                    }
        
                    return loginState
                }
            } else {
                print("Login state already exist")
                if let loginState = results.first as? LoginState {
                    loginState.isLoggedIn = isLoggedIn
                    loginState.userEmail = userEmail
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error with context save")
                    }
        
                    return loginState
                }
            }
        } catch {
            print("Error with fetching login state")
        }
        return nil
    }
    
    // MARK: Check if user logged in
    
    func checkIfUserLoggedIn() -> LoginState? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginState")
        do {
            let results = try context.fetch(fetchRequest)
            if let loginState = results.first as? LoginState {
                
              return loginState
            }
        } catch {
            print("Error")
        }
        return nil
    }
    
    // MARK: Check if user exist
    
    func checkIfUserExist(email: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@" ,email)
        let results = try! context.fetch(fetchRequest)
        
        return results.count > 0
    }
    
    // MARK: Check if password match
    
    func checkIfPasswordMatch(email:String, password: String) -> Bool {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate1 = NSPredicate(format: "email == %@" , email)
        let predicate2 = NSPredicate(format: "password == %@" , password)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        let results = try! context.fetch(fetchRequest)
        print(results)
        return results.count > 0
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
