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

class ResultMapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifier = "location_id"
    var location: CLLocation!
    var nearbyResults = [NearbyPoint]()
    var stationAnnotation: MKPointAnnotation!
    var nearbyPointsAnnotations = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        location = CLLocation(latitude: 48.8615745, longitude: 2.3470353)
        let newLocation = CLLocation(latitude: 48.859, longitude: 2.34)
        let pointInfos = [
            "test", "haha", "lol"
        ]
        let nearbyPoint = NearbyPoint(name: "Nom test", coordinate: newLocation.coordinate, description: "HAHAHAHAH", infos: pointInfos)

        nearbyResults.append(nearbyPoint)
        
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0/111.0, longitudeDelta: 1.0/111.0))
        
        mapView.setRegion(region, animated: true)
        stationAnnotation = MKPointAnnotation()
        stationAnnotation.title = "lol"
        stationAnnotation.coordinate = location.coordinate
        mapView.addAnnotation(stationAnnotation)
        
        let secondAnnotation = PlaceAnnotation(coordinate: nearbyPoint.coordinate, nearbyPoint: nearbyPoint)
        nearbyPointsAnnotations.append(secondAnnotation)
        mapView.addAnnotations(nearbyPointsAnnotations)
        mapView.register(MKAnnotationView.classForCoder(), forAnnotationViewWithReuseIdentifier: reuseIdentifier)

        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
                annotationView.image = UIImage(named: "pokeball")
                annotationView.canShowCallout = true
        
                return annotationView
            }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation as? MKPointAnnotation == stationAnnotation) {
            return
        }
        let placeAnnotation = view.annotation as? PlaceAnnotation
        if let detailView = self.storyboard?.instantiateViewController(withIdentifier: "placeDetail") as? PlaceDetailViewController {
            
            print("hellllo")
            
            detailView.point = placeAnnotation?.point
            self.navigationController?.pushViewController(detailView, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyPointCell", for: indexPath) as! NearbyPointCell
        
        cell.nearbyPoint = self.nearbyResults[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let coordinate = nearbyResults[indexPath.row].coordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0/111.0, longitudeDelta: 1.0/111.0))
            
            mapView.setRegion(region, animated: true)
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
