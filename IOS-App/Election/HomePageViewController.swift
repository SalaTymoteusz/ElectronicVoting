//
//  HomePageViewController.swift
//  Election
//
//  Created by xxx on 19.10.2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import UIKit


class HomePageViewController: UIViewController {
    
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var candidates: [Candidate] = []
    var endOfVoting = "2019-01-01"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        candidates = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        untilDate(date: endOfVoting)
    }
    
    func untilDate(date: String){
        
        let futureDate = date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let futureDateFormated : Date? = dateFormatter.date(from: futureDate)
        let difference = currentDate.timeIntervalSince(futureDateFormated!)
        let differenceInDays = Int(difference/(60 * 60 * 24)*(-1))
        dateLabelOutlet.text = "Do końca pozostało " + String(differenceInDays) + " Dni"
    }
    
    func createArray() -> [Candidate] {
        
        var tempCandidates: [Candidate] = []
        
        let candidate1 = Candidate(image: #imageLiteral(resourceName: "donald"), title: "Vote for Kukiz", votes: 124, percent: 40)
        let candidate2 = Candidate(image: #imageLiteral(resourceName: "german"), title: "Vote for Mielca", votes: 43, percent: 25)
        let candidate3 = Candidate(image: #imageLiteral(resourceName: "mask"), title: "Vote for Cicholska", votes: 24, percent: 15)
        let candidate4 = Candidate(image: #imageLiteral(resourceName: "wanda"), title: "Vote for Trzaskowski", votes: 15, percent: 10)
        let candidate5 = Candidate(image: #imageLiteral(resourceName: "donald"), title: "Vote for Tusk", votes: 4, percent: 1)
        let candidate6 = Candidate(image: #imageLiteral(resourceName: "ben"), title: "Vote for Muszynski", votes: 12, percent: 2)
        let candidate7 = Candidate(image: #imageLiteral(resourceName: "dog375x275"), title: "Vote for Kozuchowski", votes: 531, percent: 80)
        

        
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
    
}
