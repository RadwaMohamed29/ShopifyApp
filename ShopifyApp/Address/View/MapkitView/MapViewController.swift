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

    private let userDefault = Utilities()
    private var viewModel:AddressViewModel!
    @IBOutlet var mapView:MKMapView!
    private var newAddress:AddressFromMap?
    var manager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel(network: APIClient())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        mapView.delegate = self
        
        if isLocationServiceEnabled(){
            checkAuthorizationState()
        }else{
            showLocationAlert(text: "Please Enable Location..")
        }
    }
    
    @IBAction func btnConfirmAddress(_ sender: Any) {
//        getLocationInfo(location: manager.location!)
        if newAddress != nil{
            completeAddress()
        }else{
            showLocationAlert(text: "choose an address")
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getLocationInfo(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
}

extension MapViewController:CLLocationManagerDelegate{
    
    func getCurrentLocation(location:CLLocation) {
//        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
//        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance:  1000), animated: true)
        
    }
    
    func isLocationServiceEnabled() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func getLocationInfo(location:CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) {[weak self ] places, error in
            guard let place = places?.first, error == nil else{return}
            guard let self = self else{return}
            self.newAddress = AddressFromMap(streetName: place.name ?? "", city: place.administrativeArea ?? "", country: place.country ?? "")
        }  
    }
    
    func completeAddress() {
        let address = newAddress
        guard let address = address else {return}
        let phone = PhoneViewController(nibName: "PhoneViewController", bundle: nil)
        phone.address = address
        self.navigationController?.pushViewController(phone, animated: true)
    }
    
    
    func checkAuthorizationState() {
        
        switch manager.authorizationStatus{
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            self.showLocationAlert(text: "Access Restricted")
            break
        case .denied:
            self.showLocationAlert(text: "Please authorize our access to get your location..")
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
            zoomToUserLocation(location: manager.location ?? CLLocation(latitude: 30.0444, longitude: 31.2357))
            break
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
            zoomToUserLocation(location: manager.location ?? CLLocation(latitude: 30.0444, longitude: 31.2357))
            break
        default:
            print("Default")
        }
    }
    
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func zoomToUserLocation(location:CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 0.1, longitudinalMeters: 0.1)
        mapView.setRegion(region, animated: true)
        let zoom = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1200000)
        mapView.setCameraZoomRange(zoom, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .denied:
            self.showLocationAlert(text: "Please authorize our access to get your location..")
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
            zoomToUserLocation(location: manager.location ?? CLLocation(latitude: 30.0444, longitude: 31.2357))
            break
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
            zoomToUserLocation(location: manager.location ?? CLLocation(latitude: 30.0444, longitude: 31.2357))
            break
        default:
            print("Default")
        }
    }
}
