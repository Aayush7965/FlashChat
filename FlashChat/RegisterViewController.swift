//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by Aayush Pareek on 03/05/20.
//  Copyright © 2020 Aayush Pareek. All rights reserved.
//
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let registeringHUD = JGProgressHUD(style: .dark)

    
    @IBAction func registerPressed(_ sender: UIButton) {
        self.registeringHUD.textLabel.text = "Registering"
        registeringHUD.show(in: self.view)
       
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.registeringHUD.dismiss()
                    self.initialViewController()
                }
            }
        }
    }
    
    fileprivate func initialViewController() {
        if let windowScn = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let sceneDelegate = windowScn.delegate as? SceneDelegate
            var initialVC = UIViewController()
            initialVC = UIStoryboard(name: "MainApp", bundle: nil).instantiateViewController(withIdentifier: "ChatVC")
            sceneDelegate?.window?.rootViewController = initialVC
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
}
