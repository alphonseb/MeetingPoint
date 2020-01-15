//
//  HomeViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 14/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    var alert: UIAlertController!
    var userName: String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Store.users = []
        Store.isOrganizer = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Create the alert controller.
        alert = UIAlertController(title: "Ajouter un événement", message: "Créez ou rejoignez une session", preferredStyle: .actionSheet)
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Créer une session", style: .default, handler: {(action:UIAlertAction) in
            if let createView = self.storyboard?.instantiateViewController(withIdentifier: "createStepOne") as? CreateStepOneViewController {
                self.navigationController?.pushViewController(createView, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Rejoindre une session", style: .default, handler: {(action: UIAlertAction) in
            if let joinView = self.storyboard?.instantiateViewController(withIdentifier: "joinSession") as? JoinSessionViewController {
                self.navigationController?.pushViewController(joinView, animated: true)
            }
        }))
        
        let cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: cancelHandler))
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goToCreateSession(_ sender: Any) {
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
