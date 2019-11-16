//
//  CollectionViewController.swift
//  MyVirturalTourist
//
//  Created by Brittany Mason on 11/4/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class collectionViewController : UIViewController {
    
    var latitude = 0.0
    var longitude = 0.0
    var cityName = ""
    var totalPhotosCount = 0
    // Why the ? at the end of the Struct
    var pictureStruct : [PhotoParser]?
    
    @IBOutlet weak var collectionMapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(latitude, "collectionview cord")
        print(longitude)
        collectionMapView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: initialLocation)
    }
    
    
    let regionRadius: CLLocationDistance = 8000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        let locCoord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        
        collectionMapView.setRegion(coordinateRegion, animated: true)
        collectionMapView.addAnnotation(annotation)
    }
    
    
    @IBAction func getPhotoButtonPressed(_ sender: Any) {
        print("'New Collection' button pressed")
        
        
        helperTasks.downloadPhotos { (pictureInfo, error) in
            if let pictureInfo = pictureInfo {
                let totalPhotos = pictureInfo.photos.photo.count
                self.totalPhotosCount = totalPhotos
                self.pictureStruct = pictureInfo.photos.photo
                
                print(totalPhotos)
                print(pictureInfo.photos.photo)
                //                Constants.FlickrParameters.APIResults = pictureInfo
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.displayAlert(title: "Error", message: "Unable to get student locations.")
                }
                print(error as Any)
            }
        }
    }
}

        
extension collectionViewController: UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.totalPhotosCount
        }
    }

extension collectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        if let pictureStruct = pictureStruct {
            let images = pictureStruct[(indexPath as NSIndexPath).row]
            if let url = images.url {
                do {
                    let data = try Data.init(contentsOf: URL.init(string: url)!)
                    DispatchQueue.main.async {
                        cell.collectionImageViewCell.image = UIImage(data: data) ?? UIImage(named: "temp")
                    }
                }
                catch {
                    print("error")
                }
            }
        }
        return cell
    }
}

extension collectionViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 2
        let identifier = "pin"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView { // 3
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 4
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        //        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        //        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}






