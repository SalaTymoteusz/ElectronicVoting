//
//  UserProfileViewController.swift
//  Election
//
//  Created by xxx on 19/12/2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var myStory: UITextView!
    
    
    var firstNameLabel = ""
    var lastNameLabel = ""
    var ageLabel = ""
    var votesLabel = ""
    var myStoryLabel = ""
    var avatarId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemberAvatar(userId: avatarId)
        firstName.text = firstNameLabel
        lastName.text = lastNameLabel
        votes.text = votesLabel
        age.text = ageLabel
        myStory.text = myStoryLabel
        

        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        self.present(nextViewController, animated:true, completion:nil)
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
}
