//
//  HomePageViewController.swift
//  Election
//
//  Created by xxx on 19.10.2018.
//  Copyright © 2018 xxx. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
    }
    
    @IBAction func loadMemberButtonTapped(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
