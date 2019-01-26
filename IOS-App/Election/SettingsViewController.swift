import UIKit
import SwiftKeychainWrapper

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var peselLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var goCandidate: UIButton!
    @IBOutlet weak var editLastNameButton: EditSettButton!
    @IBOutlet weak var editEmailButton: EditSettButton!
    @IBOutlet weak var editDescButton: EditSettButton!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var addAvatarButton: UIButton!
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        hide(textField: true, label: false)
        loadMemberAvatar()
        loadMemberProfile()
        goCandidate.layer.borderWidth = 2.0
        goCandidate.layer.borderColor = Colors.twitterBlue.cgColor
        goCandidate.layer.cornerRadius = goCandidate.frame.size.height/2
        goCandidate.setTitleColor(Colors.twitterBlue, for: .normal)

    }

    @IBAction func addAvatarButtonTapped(_ sender: Any) {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        avatarImage.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        
        uploadImage()
    }
    
    func uploadImage() {
        let image = UIImageJPEGRepresentation(avatarImage.image!, 1)
        if image == nil { return }
        let boundary = UUID().uuidString
        
        self.addAvatarButton.isEnabled = false
        
        let userId: String? = KeychainWrapper.standard.string(forKey: "userId")
        let uploadScriptUrl = NSURL(string: "http://localhost:3000/images/avatar/\(userId!)")
        let request = NSMutableURLRequest(url: uploadScriptUrl! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        let task = session.uploadTask(with: request as URLRequest, from: image!)
        task.resume()
    }
    
     func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let myAlert = UIAlertController(title: "Alert", message: error as? String, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(myAlert, animated: true, completion: nil)
        self.addAvatarButton.isEnabled = true

    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.addAvatarButton.isEnabled = true
    }

    
    
    
    func hide(textField: Bool, label: Bool) {
        surnameTextField.isHidden = textField
        emailTextField.isHidden = textField
        descTextField.isHidden = textField
        firstNameLabel.isHidden = label
        lastNameLabel.isHidden = label
        ageLabel.isHidden = label
        emailLabel.isHidden = label
        peselLabel.isHidden = label
    }
    
    @IBAction func editLastName(_ sender: Any) {
        lastNameLabel.isHidden = true
        surnameTextField.isHidden = false
        if editLastNameButton.currentTitle == "Edit" {
        putMethod(parameters: ["surname": surnameTextField.text])
        loadMemberAvatar()
        loadMemberProfile()
        lastNameLabel.isHidden = false
        surnameTextField.isHidden = true
        }
    }
    
    @IBAction func editEmail(_ sender: Any) {
        emailLabel.isHidden = true
        emailTextField.isHidden = false
        if editEmailButton.currentTitle == "Edit" {
        putMethod(parameters: ["email": emailTextField.text])
        loadMemberAvatar()
        loadMemberProfile()
        emailLabel.isHidden = false
        emailTextField.isHidden = true
    }
    }
    
    @IBAction func editDesc(_ sender: Any) {
        descTextField.isHidden = false
        if editDescButton.currentTitle == "Edit" {
        putMethod(parameters: ["desc": descTextField.text])
        loadMemberAvatar()
        loadMemberProfile()
        descTextField.isHidden = true

        }
        
    }
    
    
    @IBAction func goCandidateButtonTapped(_ sender: Any) {
        
        if descTextView.text == "moj desc" {
            displayMessage(userMessage: "You have to add description")
            return
        } else {
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
        loadMemberProfile()
    }
    
    func putMethod(parameters: Any) {
        
        let parameters = parameters
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
                            let candidate: Bool? = parseJSON["candidate"] as? Bool


                            if firstName?.isEmpty != true && lastName?.isEmpty != true && pesel?.isEmpty != true && email?.isEmpty != true  {
                                self.firstNameLabel.text =  firstName!
                                self.lastNameLabel.text =  lastName!
                                self.ageLabel.text = String(age!)
                                self.peselLabel.text = pesel!
                                self.emailLabel.text = email!
                                self.descTextView.text = desc!
                                if candidate! == false {
                                    self.goCandidate.setTitle("BECOME A CANDIDATE", for: .normal)
                                } else {
                                    self.goCandidate.setTitle("YOU ARE A CANDIDATE", for: .normal)
                                    self.goCandidate.isEnabled = false

                                }
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


