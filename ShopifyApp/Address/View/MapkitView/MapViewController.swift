//
//  MapViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 26/06/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet var mapView:MKMapView!
    var manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
}

extension MapViewController:CLLocationManagerDelegate{
    
    
}
