//
//  List.swift
//  Election
//
//  Created by xxx on 13/12/2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import Foundation
import UIKit


class Candidate {
    
    var image: UIImage
    var name: String
    var lastName: String
    var votes: Int
    var age: Int
    var myStory: String
    

    init(image: UIImage, name: String, lastName: String, votes: Int, age: Int, myStory: String) {
        self.image = image
        self.name = name
        self.lastName = lastName
        self.votes = votes
        self.age = age
        self.myStory = myStory
    }
}

