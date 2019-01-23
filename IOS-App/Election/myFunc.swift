//
//  MyFunc.swift
//  Election
//
//  Created by xxx on 18/01/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation
import UIKit
extension SignInViewController{
class MyFunc {
    static func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
}
