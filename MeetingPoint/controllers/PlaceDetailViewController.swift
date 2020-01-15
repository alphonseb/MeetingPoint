//
//  PlaceDetailViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    var point: NearbyPoint!
    var cells = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = point.name
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
