//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Aayush Pareek on 03/05/20.
//  Copyright © 2020 Aayush Pareek. All rights reserved.
//
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let loggingHUD = JGProgressHUD(style: .dark)

    @IBAction func loginPressed(_ sender: UIButton) {
        self.loggingHUD.textLabel.text = "Logging In"
        loggingHUD.show(in: self.view)
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.showHUDWithError(error: e)
                } else {
                    self.loggingHUD.dismiss()
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
        loggingHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
}
