//
//  HomePageViewController.swift
//  Election
//
//  Created by xxx on 19.10.2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var candidates: [Candidate] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candidates = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createArray() -> [Candidate] {
        
        var tempCandidates: [Candidate] = []
        
        let candidate1 = Candidate(image: #imageLiteral(resourceName: "kukiz"), title: "Vote for Kukiz")
        let candidate2 = Candidate(image: #imageLiteral(resourceName: "pisGrzegorzMuszynski"), title: "Vote for Mielca")
        let candidate3 = Candidate(image: #imageLiteral(resourceName: "pisAnnaCicholska"), title: "Vote for Cicholska")
        let candidate4 = Candidate(image: #imageLiteral(resourceName: "poRafalTrzaskowski"), title: "Vote for Trzaskowski")
        let candidate5 = Candidate(image: #imageLiteral(resourceName: "poTusk"), title: "Vote for Tusk")
        let candidate6 = Candidate(image: #imageLiteral(resourceName: "pisGrzegorzMuszynski"), title: "Vote for Muszynski")
        let candidate7 = Candidate(image: #imageLiteral(resourceName: "pisMarcinKozuchowski"), title: "Vote for Kozuchowski")


        
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
