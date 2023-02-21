
//
//  ChatViewController.swift
//  teatApp
//
//  Created by streifik on 07.12.2022.
//

import UIKit
import CoreData

class DialogsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var simulateButton: UIBarButtonItem!
    @IBOutlet weak var dialogsTableView: UITableView!
    
    // MARK: Variables
    
    var user = User()
    var chats = [Chat]() {
        
        didSet {
            self.dialogsTableView.reloadData()
        }
    }
    var noDialogsLabel = UILabel()
    let testEmail = "test"
  
    // MARK: Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let user = Settings.shared.user {
            self.user = user
            self.loadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction func simulateButtonTapped(_ sender: UIBarButtonItem) {
        self.simulateDialogue()
    }
    
    // MARK: CoreData methods
    
    func loadData() {
        if let chats = CoreDataManager.shared.fetchChats(userEmail: user.email) {
                if chats.count == 0 {
                    self.noDialogsLabel = self.createMessageLabel(text: "No dialogue yet")
                    self.view.addSubview(self.noDialogsLabel)
                } else {
                    self.navigationItem.rightBarButtonItem = nil
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
            } else {
                print("No chats")
            }
    }
    
    func simulateDialogue () {
        
        // set test user
        
        var testUser = User()
        
        if (CoreDataManager.shared.checkIfUserExist(email: testEmail)) {
            print("Test user already exist")

            if let user = CoreDataManager.shared.fetchUserData(userEmail: testEmail){
               testUser = user
               }
           } else {
            let testUserAvatarImage = UIImage(named: "testUserAvatar")!
            if let user = CoreDataManager.shared.addUser(name: "test", surname: "test", email: testEmail, phone: 37400000000, password: "test", age: 33, profileImage: testUserAvatarImage) {
               testUser = user
           }
        }
        
        // set test chat
        
        if let testChat = CoreDataManager.shared.addChat() {
            if let testMessage = CoreDataManager.shared.addMessage(image: nil, senderName: "test", recieverName: user.name, senderEmail: testEmail, recieverEmail: user.email, text: "Hello", date: Date(), chat: testChat) {
                    testChat.firstEmail = testEmail
                    testChat.secondEmail = user.email
                    testChat.user = testUser
                    testMessage.chat = testChat
                }
            }
        self.loadData()
        self.noDialogsLabel.isHidden = true
        self.dialogsTableView.reloadData()
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
