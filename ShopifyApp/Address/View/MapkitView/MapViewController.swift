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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        if isLocationServiceEnabled(){
            checkAuthorizationState()
        }else{
            showAlert(text: "Please Enable Location..")
        }
        
    }
}



extension MapViewController:CLLocationManagerDelegate{
    
    func getCurrentLocation(location:CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
//        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance:  1000), animated: true)
        
    }
    
    func isLocationServiceEnabled() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func checkAuthorizationState() {
        
        switch manager.authorizationStatus{
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            self.showAlert(text: "Access Restricted")
            break
        case .denied:
            self.showAlert(text: "Please authorize our access to get your location..")
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
            break
        default:
            print("Default")
        }
    }
    
    func showAlert(text:String) {
        let alert = UIAlertController(title: "Location Permission", message: text, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Close", style: .destructive))
        present(alert, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            getCurrentLocation(location: location)
//            zoomToUserLocation(location: location)
            print(location.coordinate)
        }
    }
    
   
}
