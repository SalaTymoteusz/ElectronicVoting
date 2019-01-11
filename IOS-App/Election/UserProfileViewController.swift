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
    @IBOutlet weak var myStory: UILabel!
    
    var image = UIImage()
    var firstNameLabel = ""
    var lastNameLabel = ""
    var ageLabel = ""
    var votesLabel = ""
    var myStoryLabel = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.text = firstNameLabel
        lastName.text = lastNameLabel
        votes.text = votesLabel
        age.text = ageLabel
        myStory.text = myStoryLabel
        
        
        img.image = image
        img.layer.cornerRadius = img.frame.size.width / 2
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.darkGray.cgColor
        img.layer.borderWidth = 6

        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
}
