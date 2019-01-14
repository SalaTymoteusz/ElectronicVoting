//
//  SignInViewController.swift
//  Election
//
//  Created by xxx on 19.10.2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        // Read value from text fields
        let userName = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        // Check if required fields are not empty
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            //Display alert message here
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "One of the required fields is missing")
            return
        }
        
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        view.addSubview(myActivityIndicator)
        
        // Send HTTP Request
        let myUrl = URL(string: "http://localhost:3000/users/login")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST" // Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["password": userPassword!, "pesel": userName!] as [String: String]
       
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
               self.displayMessage(userMessage: "Could not successfully perform this request. Please try later")
                print("error=\(String(describing: error))")
                return
            }
            
            //Let's convert response sent from a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // Now we can access value of First Name by its key
                    let accessToken = parseJSON["token"] as? String
                    let userId = parseJSON["_id"] as? String
                    print("Access token: \(String(describing: accessToken!))")

                    
               //     let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")

            //        let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")

              //      print("The access token save resoult \(saveAccessToken)")
               //     print("The user id save resoult \(saveUserId)")
                    
                    if (accessToken?.isEmpty)!
                    {
                        //Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    }
                    
                    
                } else {
                    //Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
            } catch {
                
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
                // Display an Alert dialog with a friendly error message
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }
                
                
                
                
        }
        task.resume()
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("Register new account")
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        self.present(registerViewController, animated: true)
    }
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){(action: UIAlertAction!) in
                // Code in this block will trigger when OK button tapped.
                print("OK button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
