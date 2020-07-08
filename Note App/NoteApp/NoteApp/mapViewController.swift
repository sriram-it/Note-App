//
//  mapViewController.swift
//  NoteApp
//
//  Created by Arunkumar Nachimuthu on 2020-06-18.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    var userLocation : CLLocationCoordinate2D?
    var placeName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
        pin.title = placeName
        mapView.addAnnotation(pin)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: userLocation!.latitude,longitude: userLocation!.longitude)
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 30000, longitudinalMeters: 30000)
        mapView.setRegion(viewRegion, animated: true)
    }

}
