import UIKit
import SwiftKeychainWrapper

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var peselLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    var doIt = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadMemberProfile()
       loadMemberAvatar()
    }
    
    
    @IBAction func goCandidateButtonTapped(_ sender: Any) {
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["candidate":true]

        let userId: String? = KeychainWrapper.standard.string(forKey: "userId")
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
    
    


    
    



    func loadMemberAvatar()
    {
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let userId: String? = KeychainWrapper.standard.string(forKey: "userId")
        let avatarUrl = URL(string: "http://localhost:3000/Images/avatar/\(userId!)")

        var request = URLRequest(url:avatarUrl!)
        request.httpMethod = "GET"// Compose a query string
        request.addValue("\(accessToken!)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if error != nil
            {
                self.displayMessage(userMessage: ". Please try again later")
                print("error=\(String(describing: error))")
                return
            }


                    DispatchQueue.main.async
                        {

                            self.avatarImage.image = UIImage(data: data!)
                            self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width / 2
                            self.avatarImage.clipsToBounds = true
                            self.avatarImage.layer.borderColor = UIColor.darkGray.cgColor
                            self.avatarImage.layer.borderWidth = 6

                    }

        }
        task.resume()

    }
    
    func loadMemberProfile()
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
                            let firstName: String?  = parseJSON["name"] as? String
                            let lastName: String? = parseJSON["surname"] as? String
                            let age: Int?  = parseJSON["age"] as? Int
                            let pesel: String? = parseJSON["pesel"] as? String
                            let email: String? = parseJSON["email"] as? String
                            let desc: String? = parseJSON["desc"] as? String

                            if firstName?.isEmpty != true && lastName?.isEmpty != true && pesel?.isEmpty != true {
                                self.firstNameLabel.text =  firstName!
                                self.lastNameLabel.text =  lastName!
                                self.ageLabel.text = String(age!)
                                self.peselLabel.text = pesel!
                                self.emailLabel.text = email!
                                self.descTextView.text = desc!

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
