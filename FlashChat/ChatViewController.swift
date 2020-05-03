//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Aayush Pareek on 03/05/20.
//  Copyright © 2020 Aayush Pareek. All rights reserved.
//
//

import UIKit
import Firebase
import JGProgressHUD

class ChatViewController: UIViewController {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.layer.cornerRadius = 30
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                   self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                         self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    let logOutHUD = JGProgressHUD(style: .dark)
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        logOutHUD.textLabel.text = "Logging Out"
        logOutHUD.show(in: self.view)
        do {
            try Auth.auth().signOut()
            logOutHUD.dismiss()
            initialViewController()
        } catch let signOutError as NSError {
          showHUDWithError(error: signOutError)
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        logOutHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    fileprivate func initialViewController() {
        if let windowScn = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let sceneDelegate = windowScn.delegate as? SceneDelegate
            var initialVC = UIViewController()
            initialVC = UIStoryboard(name: "MainApp", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
            sceneDelegate?.window?.rootViewController = initialVC
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //This is a message from the current user.
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.907296598, green: 0.9260299802, blue: 0.9460733533, alpha: 1)
            cell.label.textColor = #colorLiteral(red: 0.2416263819, green: 0.2742871046, blue: 0.3809470534, alpha: 1)
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.3354867995, green: 0.4787674546, blue: 0.9523758292, alpha: 1)
            cell.label.textColor = #colorLiteral(red: 0.910656929, green: 0.9294318557, blue: 0.9939801097, alpha: 1)
        }
        
        return cell
    }
}

