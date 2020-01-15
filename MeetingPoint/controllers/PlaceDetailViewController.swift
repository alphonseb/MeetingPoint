//
//  PlaceDetailViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var point: NearbyPoint!
    var cells = [[String:AnyObject]]()
    var confirmAlert: UIAlertController!
    var choiceAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Store.isOrganizer {
            choiceAlert = UIAlertController(title: "Le choix est fait", message: "\(Store.event.organizerName) a trouvé l'endroit parfait !", preferredStyle: .alert)
            
            choiceAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                // Send to completion View
            }))
            let choiceListener = ChoiceListener()
            choiceListener.listen { (finished) in
                if (finished) {
                    self.present(self.choiceAlert, animated: true, completion: nil)
                }
            }
        }
        
        titleLabel.text = point.name
        saveButton.isHidden = !Store.isOrganizer
        
        cells.append([
            "type": "desc" as AnyObject,
            "content": point.description as AnyObject
        ])
        
        for info in point.infos {
            cells.append([
                "type": "info" as AnyObject,
                "content": info as AnyObject
                ])
        }
        
        confirmAlert = UIAlertController(title: "Valider ce lieu", message: "Valider ce lieu pour votre évènemnt ?", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Valider", style: .default, handler: {(action:UIAlertAction) in
            // Enregistrer event
            self.saveEvent()
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: {(action:UIAlertAction) in
        }))
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if ()
        if (cells[indexPath.row]["type"] as? String == "desc") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionCell
            
            cell.descriptionText = cells[indexPath.row]["content"] as? String
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
        
        cell.info = cells[indexPath.row]["content"] as? String
        
        return cell
    }
    
    @IBAction func choosePlace(_ sender: Any) {
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    func saveEvent() {
        Store.event.point = self.point
        Store.event.title = self.point.name
        
        Store.sessionRef.child("event/choosenPoint").setValue([
            "name": self.point.name!,
            "imageUrl": self.point.imageUrl ?? "",
            "coordinate": [
                "lat": self.point.coordinate.latitude,
                "lon": self.point.coordinate.longitude
            ]
            ])
        
        for info in self.point.infos {
            Store.sessionRef.child("event/choosenPoint/infos").childByAutoId().setValue(info)
        }
        
        // Core data save
        // Send to completion view
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
