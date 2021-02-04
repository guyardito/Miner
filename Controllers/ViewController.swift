//
//  ViewController.swift
//  Miner
//
//  Created by Michael Simone on 7/8/20.
//

import UIKit
import LocalAuthentication

extension LAContext: LAContextProtocol{}

protocol LAContextProtocol {
    func canEvaluatePolicy(_ : LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)
}

class Login_VC: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    let kc = KeyChainManager(KeyChain())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        activityIndicator?.startAnimating()
        
        if let receivedData = kc.load(key: "token"), let _ = String(data: receivedData, encoding: .utf16) {
            // the token is avaliable through unnamed parameter above
            // authenticate also checks if the policy can be evaluated
            BiometricsManager().authenticateUser(completion: { [weak self] (response) in
                switch response {
                    case .failure:
                        DispatchQueue.main.async {
                            self?.performSignIn((Any).self)
                        }
                    case .success:
                        DispatchQueue.main.async {
                            self?.performSegue(withIdentifier: "tabController", sender: nil)
                        }
                }
            })
        } else {
            // no token so therefore we have never logged in
            DispatchQueue.main.async {
                self.performSignIn((Any).self)
            }
        }
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
    
    @IBAction func performSignIn(_ sender: Any) {
        //        These are for testing only
        //        loginTextField.text = "admin@mhp.com"
        //        passwordTextField.text = "5!VG#ZeU#d1W1"
        
        guard let email = loginTextField.text, !(loginTextField.text?.isEmpty)! else { return }
        guard let password = passwordTextField.text, !(passwordTextField.text?.isEmpty)! else { return }
        
        let urlLis = "https://mining.blockstream.com/api/v1/user/login"
        
        let parameterDictionary = [
            "mail": email,
            "password": password,
			"rememberMe": 0
		] as [String : Any]
        
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
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "tabController", sender: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Login Error", message: "Invalid username/password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
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
    
    @IBAction func forgotPassword(_ sender: Any) {
    }
}



class TextField: UITextField {
    override var placeholder: String? {
        didSet {
            let placeholderString = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            self.attributedPlaceholder = placeholderString
        }
    }
}




enum BioError: Error {
    case General
    case NoEvaluate
}



class BiometricsManager {
    let context: LAContextProtocol
    
    init(context: LAContextProtocol = LAContext() ) {
        self.context = context
    }
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    
    func authenticateUser(completion: @escaping (Result<String, Error>) -> Void) {
        guard canEvaluatePolicy() else {
            completion( .failure(BioError.NoEvaluate) )
            return
        }
        
        let loginReason = "Log in with FaceID"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    // User authenticated successfully
                    completion(.success("Success"))
                }
            } else {
                switch evaluateError {
                    default: completion(.failure(BioError.General))
                }
                
            }
        }
    }
}
