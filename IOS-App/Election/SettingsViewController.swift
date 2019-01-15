import UIKit
import SwiftKeychainWrapper

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var peselLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemberProfile()
    
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
                            
                            if firstName?.isEmpty != true && lastName?.isEmpty != true && pesel?.isEmpty != true {
                                self.firstNameLabel.text =  firstName!
                                self.lastNameLabel.text =  lastName!
                                self.ageLabel.text = String(age!)
                                self.peselLabel.text = pesel!
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
