//
//  ChatViewController.swift
//  teatApp
//
//  Created by streifik on 08.12.2022.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    // MARK: Variables
    
    var messages = [Message]()
    var chat = Chat()
    var user = User()

    // MARK: Outlets
    
    @IBOutlet weak var messageTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageTextField: UITextField!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = chat.userName
        sendMessageButton.setImage(UIImage(named: "sendMessage"), for: .normal)
        chatTableView.separatorStyle = .none
        registerNotifications()
        sendMessageTextField.delegate = self
        
        messages = chat.messages.sorted(by: {$0.date! < $1.date!})
        chatTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        scrollToBottomOfChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Actions
    
    @IBAction func sendMessageButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        if sendMessageTextField.text != "" {
        if let text = sendMessageTextField.text {
        addMessageToCoreData(text: text)
            sendMessageTextField.text = ""
            }
        }
    }

    // MARK: CoreData methods
    
    func addMessageToCoreData(text: String) {
        if let recieverName = chat.user?.name {
            if let recieverEmail = chat.user?.email {
                if let userName = user.name {
                    if let userEmail = user.email {
                        let currentDate = Date()
                        if let message = CoreDataManager.shared.addMessage(senderName: userName, recieverName: recieverName, senderEmail: userEmail, recieverEmail: recieverEmail, text: text, date: currentDate, chat: chat) {
                            
                            messages.append(message)
                            chatTableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    // MARK: Keyboard methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.1, animations: { [self] () -> Void in
            messageTextFieldBottomConstraint.constant = (keyboardFrame.size.height - 22)
           
            if chat.messages.count != 0 {
                scrollToBottomOfChat()
            } else {
                print("no messages")
            }
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        messageTextFieldBottomConstraint.constant = -22
        view.endEditing(true)
        
        if chat.messages.count != 0 {
            scrollToBottomOfChat()
        } else {
            print("no messages")
        }
    }

    func scrollToBottomOfChat(){
        let indexPath = IndexPath(row: chat.messages.count - 1, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: TableView DataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        if let email = user.email {
            cell.configure(message: messages[indexPath.row], userEmail: email)
        }
        return cell
    }
}

// MARK: TableView Delegate
    
extension ChatViewController: UITableViewDelegate{}

// MARK: TextField Delegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
           return true
   }
}
