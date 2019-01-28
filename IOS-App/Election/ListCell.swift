//
//  ListCell.swift
//  Election
//
//  Created by xxx on 13/12/2018.
//  Copyright © 2018 xxx. All rights reserved.
//
import UIKit

class ListCell: UITableViewCell{
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var listVotesLabel: UILabel!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var listPercentLabel: UILabel!
    
    var courses = [Course]()

    
    func setCandidate(candidate: Course) {
        listTitleLabel.text = candidate.name
        listVotesLabel.text = String(candidate.votes)
        loadAllVotes(votes: Double(candidate.votes))
    }
    
    func loadAllVotes(votes: Double) {
        let urlString = "http://localhost:3000/users/?gaveVote=true"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, _, err) in
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
                    print("ile1: \(self.courses.count)")
                    if self.courses.count == 0 {
                        self.listPercentLabel.text = String(votes / 1)
                    } else {
                        print("ile: \(self.courses.count)")
                        self.listPercentLabel.text = String((votes / Double(self.courses.count)) * 100 )
                        print(self.listPercentLabel.text!)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
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
                    
                    self.listImageView.image = UIImage(data: data!)
                    self.listImageView.layer.cornerRadius = self.listImageView.frame.size.width / 2
                    self.listImageView.clipsToBounds = true
                    self.listImageView.layer.borderColor = UIColor.darkGray.cgColor
                    self.listImageView.layer.borderWidth = 6
            }
            
        }
        task.resume()
        
    }
    
}
