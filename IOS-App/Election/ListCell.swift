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
    
    func setCandidate(candidate: Candidate) {
        listImageView.image = candidate.image
        listTitleLabel.text = candidate.title
    }
}
