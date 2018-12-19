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
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var listPercentLabel: UILabel!
    @IBOutlet weak var listVotesLabel: UILabel!
    
    func setCandidate(candidate: Candidate) {
        
        listImageView.image = candidate.image
        listTitleLabel.text = candidate.title
        listPercentLabel.text = String(candidate.percent)
        listVotesLabel.text = String(candidate.votes)
        
        listImageView.layer.cornerRadius = listImageView.frame.size.width / 2
        listImageView.clipsToBounds = true
        listImageView.layer.borderColor = UIColor.darkGray.cgColor
        listImageView.layer.borderWidth = 6
    }
}
