//
//  LoaderViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import Firebase

class LoaderViewController: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        Store.sessionRef.observe(.childAdded) { (snapshot) in
            if (snapshot.exists()) {
                print(snapshot.value)
            }
        }
        
        // Listen to DB Changes
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            print("hahaha")
            self.dismiss(animated: true)
        }

        // Do any additional setup after loading the view.
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
