//
//  ResultMapViewController.swift
//  MeetingPoint
//
//  Created by Alphonse on 15/01/2020.
//  Copyright © 2020 Alphonse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import PaddingLabel

class ResultMapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stationLabel: PaddingLabel!
    
    let reuseIdentifier = "location_id"
    var location: CLLocation!
    var nearbyResults = [NearbyPoint]()
    var stationAnnotation: MKPointAnnotation!
    var nearbyPointsAnnotations = [MKAnnotation]()
    var choiceAlert: UIAlertController!
    var onlyTitle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationLabel.text = Store.meetingPoint.name
        
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
        
        self.tableView.separatorStyle = .none
        
//        location = CLLocation(latitude: 48.8615745, longitude: 2.3470353)
//        let newLocation = CLLocation(latitude: 48.859, longitude: 2.34)
//        let pointInfos = [
//            "test", "haha", "lol"
//        ]
//        let nearbyPoint = NearbyPoint(name: "Nom test", coordinate: newLocation.coordinate, description: "HAHAHAHAH", infos: pointInfos)
//
//        nearbyResults.append(nearbyPoint)
        
        let region = MKCoordinateRegion(center: Store.meetingPoint.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5/111.0, longitudeDelta: 0.5/111.0))
        
        mapView.setRegion(region, animated: true)
        stationAnnotation = MKPointAnnotation()
        stationAnnotation.title = "Point de RDV"
        stationAnnotation.coordinate = Store.meetingPoint.coordinate
        mapView.addAnnotation(stationAnnotation)
        
        for place in Store.nearbyPoints {
            let annotation = PlaceAnnotation(coordinate: place.coordinate, nearbyPoint: place)
            annotation.title = place.name
            nearbyPointsAnnotations.append(annotation)
        }
        
        
        mapView.addAnnotations(nearbyPointsAnnotations)
        mapView.register(MKAnnotationView.classForCoder(), forAnnotationViewWithReuseIdentifier: reuseIdentifier)

        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        if (annotation as? MKPointAnnotation == stationAnnotation) {
            annotationView.image = UIImage(named: "metro")
        } else {
            annotationView.image = UIImage(named: "bar")
        }
                annotationView.canShowCallout = true
        
                return annotationView
            }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation as? MKPointAnnotation == stationAnnotation) {
            return
        }
        if (!self.onlyTitle) {
            let placeAnnotation = view.annotation as? PlaceAnnotation
            if let detailView = self.storyboard?.instantiateViewController(withIdentifier: "placeDetail") as? PlaceDetailViewController {
                
                detailView.point = placeAnnotation?.point
                self.navigationController?.pushViewController(detailView, animated: true)
            }
        } else {
            self.onlyTitle = false
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                // Put your code which should be executed with a delay here
                self.mapView.deselectAnnotation(view.annotation, animated: true)
            }

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.nearbyPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyPointCell", for: indexPath) as! NearbyPointCell
        
        cell.nearbyPoint = Store.nearbyPoints[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let coordinate = Store.nearbyPoints[indexPath.row].coordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5/111.0, longitudeDelta: 0.5/111.0))
            
            mapView.setRegion(region, animated: true)
            self.onlyTitle = true
            mapView.selectAnnotation(nearbyPointsAnnotations[indexPath.row], animated: true)
            }
        
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

//extension ResultMapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        let userCoordinate = userLocation.coordinate
//
//        let region = MKCoordinateRegion(center: userCoordinate, span: MKCoordinateSpan(latitudeDelta: 20.0/111.0, longitudeDelta: 20.0/111.0))
//
//        mainMapView.setRegion(region, animated: true)
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let coordinate = annotation.coordinate
//        let userCoordinate = mapView.userLocation.coordinate
//
//        if coordinate.latitude == userCoordinate.latitude && coordinate.longitude == userCoordinate.longitude {
//            return nil
//        }
//
//        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
//
//        annotationView.image = UIImage(named: "pokeball")
//        annotationView.canShowCallout = true
//
//        return annotationView
//    }
//
//
//}
