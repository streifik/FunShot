
//
//  ChatViewController.swift
//  teatApp
//
//  Created by streifik on 07.12.2022.
//

import UIKit
import CoreData

class DialogsViewController: UIViewController {
    
    // MARK: Variables
    
    var user = User()
    var chats = [Chat]()
    var noDialogsLabel = UILabel()
    let testUserAvatarImage = UIImage(named: "testUserAvatar")!
    let testEmail = "test"
   
    // MARK: Outlets
    
    @IBOutlet weak var simulateButton: UIBarButtonItem!
    @IBOutlet weak var dialogsTableView: UITableView!
  
    // MARK: Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadData()
        dialogsTableView.reloadData()
    }
    
    // MARK: Actions
    
    @IBAction func simulateButtonTapped(_ sender: UIBarButtonItem) {
        simulateDialogue()
    }
    
    // MARK: CoreData methods
    
    func loadData() {
        if let userEmail = user.email {
            if let chats = CoreDataManager.shared.fetchChats(userEmail: userEmail) {
                if chats.count == 0 {
                    noDialogsLabel = createMessageLabel(text: "No dialogue yet")
                    view.addSubview(noDialogsLabel)
                } else {
                    navigationItem.rightBarButtonItem = nil
                }
                for chat in chats {
                    let sortedMessages = chat.messages.sorted(by: {$0.date! > $1.date!})
                    chat.lastMessage = sortedMessages.first?.text
                    chat.lastMessageDate = sortedMessages.first?.date
                    
                    for chatEmail in [chat.firstEmail, chat.secondEmail] {
                        if let email = chatEmail {
                            if email != user.email {
                                if let user = CoreDataManager.shared.fetchUserData(userEmail: email) {
                                    chat.user = user
                                    chat.userName = user.name
                                    CoreDataManager.shared.saveContext()
                                }
                            }
                        }
                    }
                }
                self.chats = chats.sorted(by: {$0.lastMessageDate! > $1.lastMessageDate!})
            }
        } else {
            print("No chats")
        }
    }
    
    func simulateDialogue () {
        // set test user
        
        var testUser = User()
        
        if CoreDataManager.shared.checkIfUserExist(email: testEmail) == true {
            print("Test user already exist")

            if let user = CoreDataManager.shared.fetchUserData(userEmail: testEmail){
               testUser = user
            }
           } else {
           if let user = CoreDataManager.shared.addUser(name: "test", surname: "test", email: testEmail, password: "test", age: 33, profileImage: testUserAvatarImage) {
               testUser = user
           }
        }
        
        // set test chat
        
        if let testChat = CoreDataManager.shared.addChat() {
            let currentDate = Date()
            if let recieverName = user.name {
                if let recieverEmail = user.email {
                    if let testMessage = CoreDataManager.shared.addMessage(senderName: "test", recieverName: recieverName, senderEmail: testEmail, recieverEmail: recieverEmail, text: "Hello", date: currentDate, chat: testChat) {
                        testChat.firstEmail = testEmail
                        testChat.secondEmail = recieverEmail
                        testChat.user = testUser
                        testMessage.chat = testChat
                        }
                    }
                }
            }
        loadData()
        noDialogsLabel.isHidden = true
        dialogsTableView.reloadData()
    }
}

        
// MARK: TableView DataSource

extension DialogsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DialogsTableViewCell
    
        cell.configure(chat: chats[indexPath.row])
    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NavigationManager.shared.navigateToChatViewController(sender: self, user: user, chat: chats[indexPath.row])
    }
}
    
// MARK: TableView Delegate

extension DialogsViewController: UITableViewDelegate {}
