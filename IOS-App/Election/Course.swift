//
//  Course.swift
//  swift4_1_json_decode
//
//  Created by xxx on 21/01/2019.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import Foundation

class Course: Decodable {
    let _id: String
    let name: String
    let surname: String
    let email: String
    let candidate: Bool
    let votes: Int
    let gaveVote: Bool
    let pesel: String
    let desc: String
    let age: Int
    
    
    
    // swift 4.0
    private enum CodingKeys: String, CodingKey {
        case _id, name, surname, email, pesel, desc
        case candidate, gaveVote
        case age, votes
    }
}
