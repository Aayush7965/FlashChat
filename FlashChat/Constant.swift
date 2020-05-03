//
//  Constant.swift
//  FlashChat
//
//  Created by Aayush Pareek on 03/05/20.
//  Copyright © 2020 Aayush Pareek. All rights reserved.
//


struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let appName = "⚡️FlashChat"

    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
