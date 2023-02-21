//
//  ChatViewController.swift
//  teatApp
//
//  Created by streifik on 08.12.2022.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var attachedImagesView: UIView!
    @IBOutlet weak var messageTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageTextField: UITextField!
    @IBOutlet weak var attachedImagesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachedImagesCollectionView: UICollectionView!
    
    // MARK: Variables
    var isHidden: Bool = true
    var messages = [Message]()
    var chat = Chat()
    var user = User()
    var attachedImages = [UIImage]()
    
    var attachedImage: UIImage! {
        didSet {
            self.attachedImages.append(self.attachedImage)
            if self.attachedImages.count == 0 {
                attachedImagesCollectionViewHeightConstraint.constant = 0
                attachedImagesView.isHidden = true
                self.view.layoutIfNeeded()

            } else {
                attachedImagesView.isHidden = false
                attachedImagesCollectionViewHeightConstraint.constant = 82
                print(attachedImages.count)
                attachedImagesCollectionView.reloadData()
                self.scrollToBottomOfChat()
            }
        }
    }
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.rowHeight = UITableView.automaticDimension
        attachedImagesCollectionViewHeightConstraint.constant = 0
        attachedImagesView.isHidden = true
        
        
        self.setUpUserInterface()
        self.registerNotifications()
        self.sendMessageTextField.delegate = self
        self.messages = chat.messages.sorted(by: {$0.date! < $1.date!})
        self.chatTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        self.scrollToBottomOfChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpUserInterface() {
        self.title = chat.userName
        let sendMessageImage = UIImage(named: "sendMessage")
        let tintedImage = sendMessageImage?.withRenderingMode(.alwaysTemplate)
        self.sendMessageButton.setImage(tintedImage, for: .normal)
        self.sendMessageButton.tintColor = .darkGray
        self.sendMessageButton.imageView?.contentMode = .scaleAspectFit
        self.chatTableView.separatorStyle = .none
      
    }
    
    // MARK: Actions
    
    @IBAction func attachButtonTapped(_ sender: Any) {
        let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
             
            self.present(image, animated: true)
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: UIButton) {
     
        if sendMessageTextField.text != "" {
        if let text = sendMessageTextField.text {
            self.addMessageToCoreData(text: text)
            self.sendMessageTextField.text = ""
            }
        }
        
        if self.attachedImages.count != 0 {
            self.showActivityIndicator()
            if let image = attachedImages.first {
                self.addImageMessageToCoreData(image: image)
                
                self.chatTableView.reloadData()
                self.scrollToBottomOfChat()
                if let index = attachedImages.firstIndex(of: image) {
                    self.attachedImages.remove(at: index)
                    self.attachedImagesCollectionView.reloadData()
                    self.hideActivityIndicator()
                    if self.attachedImages.count == 0 {
                        self.attachedImagesCollectionViewHeightConstraint.constant = 0
                        self.attachedImagesView.isHidden = true

                    } else {
                        self.attachedImagesView.isHidden = false
                        self.attachedImagesCollectionViewHeightConstraint.constant = 82
                        self.attachedImagesCollectionView.reloadData()
                        self.scrollToBottomOfChat()
                    }
                }
            }
        }
        
        self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollToBottomOfChat()
    }

    // MARK: CoreData methods
    
    func addMessageToCoreData(text: String) {
        if let recieverName = chat.user?.name {
            if let recieverEmail = chat.user?.email {
                if let message = CoreDataManager.shared.addMessage(image: nil, senderName: user.name, recieverName: recieverName, senderEmail: user.email, recieverEmail: recieverEmail, text: text, date: Date(), chat: chat) {
                    self.messages.append(message)
                    self.chatTableView.reloadData()
                }
            }
        }
    }
    
    func addImageMessageToCoreData(image: UIImage) {
        if let recieverName = chat.user?.name {
            if let recieverEmail = chat.user?.email {
                if let message = CoreDataManager.shared.addMessage(image: image, senderName: user.name, recieverName: recieverName, senderEmail: user.email, recieverEmail: recieverEmail, text: nil, date: Date(), chat: chat) {
                    self.messages.append(message)
                   // self.chatTableView.reloadData()
                }
            }
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.chatTableView.reloadData()
    }

    // MARK: Keyboard methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.1, animations: { [self] () -> Void in
            self.messageTextFieldBottomConstraint.constant = (keyboardFrame.size.height + 6)
            
            if self.chat.messages.count != 0 {
               
              //  self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
                self.chatTableView.layoutIfNeeded()
                self.scrollToBottomOfChat()
            } else {
                print("no messages")
            }
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.messageTextFieldBottomConstraint.constant = 6
        self.view.endEditing(true)
        
        if self.chat.messages.count != 0 {
            self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.scrollToBottomOfChat()
        } else {
            print("no messages")
        }
    }

    func scrollToBottomOfChat(){
        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: TableView DataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        cell.configure(message: messages[indexPath.row], userEmail: user.email)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 414, height: 1))
        label.backgroundColor = .lightGray
        return label
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.3
    }
}

// MARK: TableView Delegate
    
extension ChatViewController: UITableViewDelegate {}

// MARK: TextField Delegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return attachedImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)  as! AttachedImagesCollectionViewCell
        let image = attachedImages[indexPath.row]
        cell.attachedImageView.image = image
        if let index = attachedImages.firstIndex(where: {$0 == image}) {
            cell.imageIndex = index
        }
       
        cell.attachedImageView.layer.cornerRadius = 7
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

}
extension ChatViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.attachedImage = editedImage
            picker.dismiss(animated: true, completion: nil)
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.attachedImage = originalImage
            picker.dismiss(animated: true, completion: {
                self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            })
        }
    }
}

extension ChatViewController: UINavigationControllerDelegate {}

extension ChatViewController: AttachedImagesCollectionViewCellDelegate {
    func closeButtonTapped(index: Int) {
        print(index)
        attachedImages.remove(at: index)
        attachedImagesCollectionView.reloadData()
        
        if self.attachedImages.count == 0 {
            attachedImagesCollectionViewHeightConstraint.constant = 0
            attachedImagesView.isHidden = true

        } else {
            attachedImagesView.isHidden = false
            attachedImagesCollectionViewHeightConstraint.constant = 82
            attachedImagesCollectionView.reloadData()
            self.scrollToBottomOfChat()
        }
//
   }
    

}
