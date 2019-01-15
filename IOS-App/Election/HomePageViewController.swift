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
    var candidates: [Candidate] = []
    var endOfVoting = "2019-01-11"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candidates = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        untilDate(date: endOfVoting)
    }
    
    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "userId")
        
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
        
    }
    
    func untilDate(date: String){
        
        let futureDate = date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let futureDateFormated : Date? = dateFormatter.date(from: futureDate)
        let difference = currentDate.timeIntervalSince(futureDateFormated!)
        let differenceInDays = Int(difference/(60 * 60 * 24)*(-1)+1)
        dateLabelOutlet.text = "Do końca pozostało " + String(differenceInDays) + " Dni"
    }
    
    func createArray() -> [Candidate] {
        
        var tempCandidates: [Candidate] = []
        
        let candidate1 = Candidate(image: #imageLiteral(resourceName: "donald"), name: "Kukiz", lastName: "Kot", votes: 124, age: 52,
                                   myStory: "Lorem ipsum dolor sit amet, phasellus augue morbi mauris eget tristique sit, donec auctor suspendisse enim in, et nulla elementum pellentesque adipiscing vestibulum dolor, amet erat ante maecenas quam. Wisi mauris, aenean molestie ipsum feugiat, orci in justo, placerat lacus justo")
        let candidate2 = Candidate(image: #imageLiteral(resourceName: "german"), name: "Mielca", lastName: "Pies",votes: 43, age: 49,
                                   myStory: "Lorem ipsum dolor sit amet, phasellus augue morbi mauris eget tristique sit, donec auctor suspendisse enim in, et nulcing vestibulum dolor, amet erat ante maecenas quam. Wisi mauris, aenean molestie ipsum feugiat, orci in justo, placerat lacus justo")
        let candidate3 = Candidate(image: #imageLiteral(resourceName: "mask"), name: "Cicholska", lastName: "Rybka", votes: 24, age: 33,
                                   myStory: "Lorem ipsum dolor sit amet, phasellus augue morbi mauris eget tristique sit, donec auctor suspendisse enim instibulum dolor, amet erat ante maecenas quam. Wisi mauris, aenean molestie ipsum feugiat, orci in justo, placerat lacus justo")
        let candidate4 = Candidate(image: #imageLiteral(resourceName: "wanda"), name: "Trzaskowski", lastName: "Martins", votes: 15, age: 60,
                                   myStory: "Lorem ipsum drat lacus justo")
        let candidate5 = Candidate(image: #imageLiteral(resourceName: "donald"), name: "Tusk", lastName: "Sala", votes: 4, age: 58,
                                   myStory: "Lorem ipsum dolor sit amet, phasellus augue morbi mauris eget tristique sit, donec auctor suspendisse enim in, et nulla elementum pellentesque adipiscing vestibulum dolor, amet erat ante maecenas quam. Wisi mauris, aenean molestie ipsum feugiat, orci in justo, placerat lacus justo")
        let candidate6 = Candidate(image: #imageLiteral(resourceName: "ben"), name: "Muszynski", lastName: "Wir", votes: 12, age: 43,
                                   myStory: "Lorem ipsm dolor, amet erat ante maecenas quam. Wisi mauris, aenean molestie ipsum feugiat, orci in justo, placerat lacus justo")
        let candidate7 = Candidate(image: #imageLiteral(resourceName: "dog375x275"), name: "Kozuchowski", lastName: "Wiss", votes: 531, age: 45,
                                   myStory: "Lorem ipsum dolor sit amet, phasellus augue morbi mauris eget tristique sit, donec auctor suspendisse enim in, et nulla elementum pellentesque adipiscing vestibulum dolor, amet erat ante maecenas quam. Wisi mauris, aenean molestie ipsum feugiat, orci in justo, placerat lacus justo")
        

        
        tempCandidates.append(candidate1)
        tempCandidates.append(candidate2)
        tempCandidates.append(candidate3)
        tempCandidates.append(candidate4)
        tempCandidates.append(candidate5)
        tempCandidates.append(candidate6)
        tempCandidates.append(candidate7)
        
        return tempCandidates
    }
    

}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let candidate = candidates[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
        
        cell.setCandidate(candidate: candidate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
        vc?.image = candidates[indexPath.row].image
        vc?.firstNameLabel = candidates[indexPath.row].name
        vc?.lastNameLabel = candidates[indexPath.row].lastName
        vc?.votesLabel = String(candidates[indexPath.row].votes)
        vc?.ageLabel = String(candidates[indexPath.row].age)
        vc?.myStoryLabel = candidates[indexPath.row].myStory
        self.present(vc!, animated:true, completion:nil)
    }
    
    
    
} 
