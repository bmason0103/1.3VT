//
//  MapViewController.swift
//  MyVirturalTourist
//
//  Created by Brittany Mason on 11/3/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import Foundation
import MapKit


class MapViewController: UIViewController  {
    struct Pin {
        let lat: Double
        let long: Double
    }
    
      

    
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    var pinAnnotation: MKPointAnnotation? = nil
    var cityName = ""
    
    //MARK: Pre-setup
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        singleTap.numberOfTapsRequired = 3
        singleTap.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(singleTap)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print(coordinate)
            //Now use this coordinate to add annotation on map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            //Set title and subtitle if you want
            
            Constants.Coordinate.latitude = coordinate.latitude
            Constants.Coordinate.longitude = coordinate.longitude
            print("This is constant", Constants.Coordinate.longitude)
           
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in
                    
                    // Place details
                    guard let placeMark = placemarks?.first else { return }
                    
                    // City
                    if let city = placeMark.subAdministrativeArea {
                        print(city)
                       
                        self.cityName = city
                        print(self.cityName)
                        annotation.title = self.cityName
                    }
                    
            }
                
            )
            
            Constants.Coordinate.city = cityName
            annotation.subtitle = "subtitle"
            self.mapView.addAnnotation(annotation)
            print(Constants.Coordinate.city, "saved name")

        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionViewSegue" {
            if let collectionVC = segue.destination as? collectionViewController {
                let sender = sender as! Pin
                collectionVC.latitude = sender.lat
                collectionVC.longitude = sender.long
               
            }
        }
    }
    
    
    
}
//MARK: MKMapViewDelegate
//*********************************************//
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
          //Add code in here about transitioning to other view
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }

        mapView.deselectAnnotation(annotation, animated: true)
        print("\(#function) lat \(annotation.coordinate.latitude) lon \(annotation.coordinate.longitude)")
        let lat = annotation.coordinate.latitude
        let lon = annotation.coordinate.longitude
        let pin = Pin(lat:lat,long:lon)
        //        {
//            if isEditing {
//                mapView.removeAnnotation(annotation)
//                CoreDataStack.shared().context.delete(pin)
//                save()
                return
            
            performSegue(withIdentifier: "collectionViewSegue", sender: pin)
        }
    }
    
    
    









