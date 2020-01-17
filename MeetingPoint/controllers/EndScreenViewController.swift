//
//  EndScreenViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 17/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit

class EndScreenViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        if (Store.isOrganizer) {
            titleLabel.text = "Bravo, tu as réussi"
            taglineLabel.text = "Sans toi tes potes ne seraient rien !"
            imgView.image = UIImage(named: "success")
        } else {
            titleLabel.text = "Bravo,c'est créé !"
            taglineLabel.text = "L’organisateur a choisi un lieu, comme quoi on peut tous se mettre d’accord."
            imgView.image = UIImage(named: "success_group")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goHome(_ sender: Any) {
       
       Store.homeEventDisplayed = true
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
