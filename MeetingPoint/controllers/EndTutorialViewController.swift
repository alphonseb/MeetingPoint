//
//  EndTutorialViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 17/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit

class EndTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func dismiss(_ sender: Any) {
        Store.tutorialComplete = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
