//
//  HomePageViewController.swift
//  Election
//
//  Created by xxx on 19.10.2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class HomePageViewController: UIViewController {
    
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var courses = [Course]()
    var endOfVoting = "2019-01-30"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whoWon(untilDate: untilDate(date: endOfVoting))
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
    }
 

    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "userId")
        
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
        
    }
    
    
    func whoWon(untilDate: Int) {
        if untilDate == 0 {
            fetchJSON(url: "http://localhost:3000/users?candidate=true&sortBy=votes,Down&limit=1")
            dateLabelOutlet.text = "WINNER"
        } else {
            fetchJSON(url: "http://localhost:3000/users/?candidate=true")
        }
        
    }
    
    func untilDate(date: String) -> Int{
        
        let futureDate = date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let futureDateFormated : Date? = dateFormatter.date(from: futureDate)
        let difference = currentDate.timeIntervalSince(futureDateFormated!)
        let differenceInDays = Int(difference/(60 * 60 * 24)*(-1)+1)
        dateLabelOutlet.text = "  Zostało:\(String(differenceInDays)) dni"
        
        return differenceInDays
    }
    

    
    func fetchJSON(url: String) {
        let urlString = url
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    // link in description for video on JSONDecoder
                    let decoder = JSONDecoder()
                    // Swift 4.1
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.courses = try decoder.decode([Course].self, from: data)
                    self.tableView.reloadData()
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
    }
    

    
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let course = courses[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
        
        cell.setCandidate(candidate: course)
        cell.loadMemberAvatar(userId: course._id)

        return cell
}

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
        vc?.avatarId = courses[indexPath.row]._id
        vc?.firstNameLabel = courses[indexPath.row].name
        vc?.lastNameLabel = courses[indexPath.row].surname
        vc?.votesLabel = String(courses[indexPath.row].votes)
        vc?.ageLabel = String(courses[indexPath.row].age)
        vc?.myStoryLabel = courses[indexPath.row].desc
        vc?.candidateId = courses[indexPath.row]._id
        self.present(vc!, animated:true, completion:nil)
    }
    

}
