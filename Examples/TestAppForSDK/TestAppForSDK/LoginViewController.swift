//
//  ViewController.swift
//  TestAppForSDK
//
//  Created by Nikolay on 02.05.17.
//  Copyright © 2017 Lognex. All rights reserved.
//

import UIKit
import MoySkladSDK

class LoginViewController: UIViewController {

    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loginInput.keyboardType = .emailAddress
        loginInput.returnKeyType = .next
        
        passwordInput.isSecureTextEntry = true
        passwordInput.returnKeyType = .done
        
        activityIndicator.stopAnimating()
        
        loginInput.text = ""
        passwordInput.text = ""
    }
    
    private func validateForm(fields: [UITextField]) -> Bool {
        var isValid = true
        
        for field in fields {
            if var value = field.text {
                value = value.trimmingCharacters(in: .whitespacesAndNewlines)
                if value.isEmpty {
                    field.becomeFirstResponder()
                    isValid = false
                    break
                }
            }
        }
        
        return isValid
    }
    
    @IBAction func touchLoginButton(_ sender: UIButton) {
        
        if (validateForm(fields: [loginInput, passwordInput])) {
            sender.isEnabled = false
            let login = loginInput.text!
            let password = passwordInput.text!
            
            let auth = Auth(username: login, password: password)
            activityIndicator.startAnimating()
            
            _ = DataManager.logIn(auth: auth).do(onError: { [unowned self, weak sender] errors in
                sender?.isEnabled = true
                self.activityIndicator.stopAnimating()
                
                let errorMessage = handleMSError(errors)
                
                let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
                let alertActions = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(alertActions)
                self.present(alert, animated: true, completion: nil)
                
            }).subscribe(onCompleted: { [unowned self, weak sender] _ in
                sender?.isEnabled = true
                self.activityIndicator.stopAnimating()
                
                let ListVC = ListViewController()
                ListVC.auth = auth
                
                self.present(ListVC, animated: true, completion: nil)
            })
        }
    }
}
