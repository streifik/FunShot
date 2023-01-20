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
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail)
        
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
    
    func fetchChats(userEmail: String, companionEmail: String) -> [Chat]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        
        let p1 = NSPredicate(format: "ANY chatEmails.email == %@", "test")
        let p2 = NSPredicate(format: "ANY chatEmails.email == %@", "\(userEmail)")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        
        fetchRequest.predicate = andPredicate

        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            return results as? [Chat]
            
        } catch {
            print("Error")
        }
        return nil
    }
    
    // MARK: Add User
    
    func addUser(name: String, surname: String, email: String, password: String, age: Int, profileImage: UIImage) {
        
        let context = persistentContainer.viewContext
        if let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: context) {
            let managedObject = NSManagedObject(entity: entityDescription, insertInto: context) 
            
            managedObject.setValue(name, forKey: "name")
            managedObject.setValue(surname, forKey: "surname")
            managedObject.setValue(email, forKey: "email")
            managedObject.setValue(password, forKey: "password")
            managedObject.setValue(age, forKey: "age")
            managedObject.setValue(profileImage.pngData(), forKey: "profileImage")
            
            saveContext()
            
            }
        }
    
    // MARK: Add Chat
    
    func addChat() -> Chat? {
        let context = persistentContainer.viewContext
        let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as! Chat
        
        return chat
        
    }
    
    // MARK: Add Message
    
    func addMessage(senderName: String?, recieverName: String?, senderEmail: String?, recieverEmail: String?, text: String?, date : Date?, chat: Chat) -> Message? {
       
        let context = persistentContainer.viewContext
         let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
         
         message.senderName = senderName
         message.recieverName = recieverName
         message.senderEmail = senderEmail
         message.recieverEmail = recieverEmail
         message.text = text
         message.chat = chat
         message.date = date
         
         return message
    }
    
    // MARK: Set Chat Emails
    
    func setChatEmails(userEmail: String, companionEmail: String) -> [ChatEmail]? {
        let context = persistentContainer.viewContext
     
            let testChatFirstEmail = NSEntityDescription.insertNewObject(forEntityName: "ChatEmail", into: context) as! ChatEmail
            testChatFirstEmail.email = companionEmail

            let testChatSecondEmail = NSEntityDescription.insertNewObject(forEntityName: "ChatEmail", into: context) as! ChatEmail
            testChatSecondEmail.email = userEmail

            return [testChatFirstEmail, testChatSecondEmail]
    }
    
    // MARK: Check if user not exist
    
    func checkIfUserNotExist(email: String) -> Bool {

        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        fetchRequest.predicate = NSPredicate(format: "userEmail == %d" ,email)
       
        do {
            let count = try context.count(for: fetchRequest)
            
            if count > 0 {
                return false
            } else {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
            }
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
