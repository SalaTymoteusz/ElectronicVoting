//
//  UserProfileViewController.swift
//  Election
//
//  Created by xxx on 19/12/2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var myStory: UITextView!
    @IBOutlet weak var voteButton: UIButton!
    
    
    var firstNameLabel = ""
    var lastNameLabel = ""
    var ageLabel = ""
    var votesLabel = ""
    var myStoryLabel = ""
    var avatarId = ""
    var candidateId = ""
    let userId: String? = KeychainWrapper.standard.string(forKey: "userId")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGaveVote()
        loadMemberAvatar(userId: avatarId)
        firstName.text = firstNameLabel
        lastName.text = lastNameLabel
        votes.text = votesLabel
        age.text = ageLabel
        myStory.text = myStoryLabel
        
        
        voteButton.setTitle("VOTE", for: .normal)
        voteButton.layer.borderWidth = 2.0
        voteButton.layer.borderColor = Colors.twitterBlue.cgColor
        voteButton.layer.cornerRadius = voteButton.frame.size.height/2
        voteButton.setTitleColor(Colors.twitterBlue, for: .normal)

        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func voteButtonTapped(_ sender: Any) {
        let newNumberOfVotes = (Int(votesLabel)!)+1
        putMethod(parameters: ["votes": newNumberOfVotes], id: candidateId)
        putMethod(parameters: ["gaveVote": true], id: userId!)
        votes.text = String(newNumberOfVotes)
        loadGaveVote()
    }
    
    func loadGaveVote()
    {
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let userId: String? = KeychainWrapper.standard.string(forKey: "userId")
        
        //Send HTTP Request to perform Sign in
        let myUrl = URL(string: "http://localhost:3000/users/\(userId!)")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"// Compose a query string
        request.addValue("\(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                self.displayMessage(userMessage: ". Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    DispatchQueue.main.async
                        {
                            let gaveVote: Bool? = parseJSON["gaveVote"] as? Bool
                            if gaveVote! == false {
                                self.voteButton.setTitle("VOTE", for: .normal)
                            } else {
                                self.voteButton.setTitle("YOU VOTED", for: .normal)
                                self.voteButton.isEnabled = false
                                
                            }
                            
                    }
                } else {
                    //Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: " perform this request. Please try again later")
                }
                
            } catch {
                // Display an Alert dialog with a friendly error message
                self.displayMessage(userMessage: "Could not y perform this request. Please try again later")
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    func putMethod(parameters: Any, id: String) {
        
        let parameters = parameters
        let userId: String? = id
        //create the url with URL
        let url = URL(string: "http://localhost:3000/users/\(userId!)") //change the url
        
        //create the session object
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT" //set http method as POST
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again")
            return
        }
        
        
        //create dataTask using the session object to send data to the server
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
        }
        task.resume()
    }
    func loadMemberAvatar(userId: String)
    {
        let userId = userId
        let avatarUrl = URL(string: "http://localhost:3000/Images/avatar/\(userId)")
        
        var request = URLRequest(url:avatarUrl!)
        request.httpMethod = "GET"// Compose a query string
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                // self.displayMessage(userMessage: ". Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            
            DispatchQueue.main.async
                {
                    
                    self.img.image = UIImage(data: data!)
                    self.img.layer.cornerRadius = self.img.frame.size.width / 2
                    self.img.clipsToBounds = true
                    self.img.layer.borderColor = UIColor.darkGray.cgColor
                    self.img.layer.borderWidth = 6
            }
            
        }
        task.resume()
        
    }
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
}
