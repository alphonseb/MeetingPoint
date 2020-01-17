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

    @IBOutlet weak var event2Image: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    var alert: UIAlertController!
    var userName: String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Store.users = []
        Store.isOrganizer = false
        
        if (Store.homeEventDisplayed) {
            event2Image.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!Store.tutorialComplete) {
            if let tutorialView = self.storyboard?.instantiateViewController(withIdentifier: "tutorial") as? UIViewController {
                
                self.navigationController?.pushViewController(tutorialView, animated: true)
                
            }}
        
        event2Image.isHidden = true
        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.15
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        addButton.layer.shadowRadius = 6
        
        addButton.layer.cornerRadius = 6
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.clear.cgColor
        
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
