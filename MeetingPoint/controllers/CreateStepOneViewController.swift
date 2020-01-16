//
//  CreateStepOneViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 14/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit

class CreateStepOneViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextField!
    
    var emptyAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        
        emptyAlert = UIAlertController(title: "Attention", message: "Vous devez saisir obligatoirement votre prénom", preferredStyle: .alert)
        
        emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) -> Void in
        }))

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Store.users = []
    }
    
    @IBAction func startSession(_ sender: Any) {
        if (nameField.text == "") {
            self.present(emptyAlert, animated: true, completion: nil)
        } else {
            Store.event = Event()
            Store.event.description = self.descriptionField.text ?? "Pas de description :("
            let timestamp = self.dateField.date.timeIntervalSince1970
            Store.event.date = timestamp
            Store.event.organizerName = self.nameField.text
            
            if let createView = self.storyboard?.instantiateViewController(withIdentifier: "createSession") as? CreateSessionViewController {
                
                createView.userName = self.nameField.text
                self.navigationController?.pushViewController(createView, animated: true)
            }
        }
    }
    

}
