//
//  ListCell.swift
//  Election
//
//  Created by xxx on 13/12/2018.
//  Copyright © 2018 xxx. All rights reserved.
//
import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var listVotesLabel: UILabel!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var listPercentLabel: UILabel!
    
    func setCandidate(candidate: Course) {
        listTitleLabel.text = candidate.name
        listPercentLabel.text = String(candidate.votes / 10)
        listVotesLabel.text = String(candidate.votes)
        

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
