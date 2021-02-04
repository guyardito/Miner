//  SettingsViewController.swift
//
//  Created for Miner by Michael Simone
//

import UIKit

class Settings_VC: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// These are for when the keyboard covers over the texttfields leaving the user unable to type
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        guard let email = loginTextField.text, !(loginTextField.text?.isEmpty)! else { return }
        guard let password = passwordTextField.text, !(passwordTextField.text?.isEmpty)! else { return }
        
        let urlLis = "https://mining.blockstream.com/api/v1/user/update"
        
        let parameterDictionary = [
            "mail": email,
            "password": password
        ]
        
        let Url = String(format: urlLis)
                guard let serviceUrl = URL(string: Url) else { return }
                var request = URLRequest(url: serviceUrl)
                request.httpMethod = "POST"
                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                    return
                }
                request.httpBody = httpBody

                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let response = response {
                        print(response)
                    }
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print(json)
                        } catch {
                            print(error)
                        }
                    }
                    }.resume()
    }
    
}
