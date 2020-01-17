//
//  PlaceDetailViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import AlamofireImage

class PlaceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    var point: NearbyPoint!
    var cells = [[String:AnyObject]]()
    var confirmAlert: UIAlertController!
    var choiceAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = point.name
        
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        
        tableView.separatorStyle = .none
        
        if let imageUrl = point.imageUrl {
            imageView.af_setImage(withURL: imageUrl)
        } else {
            imageView.image = UIImage(named: "bar_default")
        }
        
        if !Store.isOrganizer {
            choiceAlert = UIAlertController(title: "Le choix est fait", message: "", preferredStyle: .alert)
            
            choiceAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                // Send to completion View
                if let endView = self.storyboard?.instantiateViewController(withIdentifier: "endScreen") as? EndScreenViewController {
                    
                    self.navigationController?.pushViewController(endView, animated: true)
                    
                }
            }))
            let choiceListener = ChoiceListener()
            choiceListener.listen { (finished) in
                if (finished) {
                    self.choiceAlert.message = "\(Store.event.organizerName) a trouvé l'endroit parfait : \(Store.event.point.name) !"
                    self.present(self.choiceAlert, animated: true, completion: nil)
                }
            }
        }
        
        titleLabel.text = point.name
        saveButton.isHidden = !Store.isOrganizer
        
        let random = Int.random(in: 0..<11)
        
        if let adress = point.adress {
            cells.append([
                "type": "info" as AnyObject,
                "content": adress as AnyObject,
                "icon": UIImage(named: "map_pin") as AnyObject
                ])
        }

        if let price = point.priceLevel {
            cells.append([
                "type": "info" as AnyObject,
                "content": price as AnyObject,
                "icon": UIImage(named: "price") as AnyObject
                ])
        }
        
        if let rating = point.rating {
            cells.append([
                "type": "info" as AnyObject,
                "content": rating as AnyObject,
                "icon": UIImage(named: "star") as AnyObject
                ])
        }
        
        if (random < 6) {
            cells.append([
                "type": "info" as AnyObject,
                "content": "Partenaire La Fourchette" as AnyObject,
                "icon": UIImage(named: "fourchette") as AnyObject
                ])
        }
        
        cells.append([
            "type": "desc" as AnyObject,
            "content": point.description as AnyObject
        ])
        
        confirmAlert = UIAlertController(title: "Valider ce lieu", message: "Valider ce lieu pour votre évènement ?", preferredStyle: .alert)
        
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
            cell.descriptionText = point.description
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
        
        cell.info = cells[indexPath.row]["content"]
        cell.picto = cells[indexPath.row]["icon"] as? UIImage
        
        return cell
    }
    
    @IBAction func choosePlace(_ sender: Any) {
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    func saveEvent() {
        Store.event.point = self.point
        Store.event.title = self.point.name
        Store.sessionRef.child("event/choosenPoint").setValue(Store.nearbyPoints.firstIndex(where: { (point) -> Bool in
            return (point.id == self.point.id)
        }))
        
        if let endView = self.storyboard?.instantiateViewController(withIdentifier: "endScreen") as? EndScreenViewController {
            
            self.navigationController?.pushViewController(endView, animated: true)
            
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
