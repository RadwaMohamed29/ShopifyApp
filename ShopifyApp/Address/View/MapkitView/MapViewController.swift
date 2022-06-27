//
//  MapViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 26/06/2022.
//

import UIKit
import MapKit
import CoreLocation

protocol PhoneDelegate {
    func getPhone(phone:String)
}

class MapViewController: UIViewController, PhoneDelegate{
    
    var address:AddressFromMap!
    var isAddressSucceded:Bool!
    var phone:String?
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
    
    func getPhone(phone: String) {
        self.phone = phone
    }
    
    @IBAction func btnAddPhone(_ sender: Any) {
        let phone = PhoneViewController(nibName: "PhoneViewController", bundle: nil)
        phone.phoneDelegate = self
        self.navigationController?.present(phone, animated: true)
    }
    
    @IBAction func btnConfirmAddress(_ sender: Any) {
        if newAddress != nil{
            postAddress()
        }else{
            showLocationAlert(text: "something went wrong ... make sure you're connected")
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getLocationInfo(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
}

extension MapViewController:CLLocationManagerDelegate{
    
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
    
    func postAddress() {
        address = newAddress
        guard let phone = phone else { showLocationAlert(text: "Please add your phone first"); return}
        self.viewModel.getAddDetailsAndPostToCustomer(customerID: String((self.userDefault.getCustomerId())), phone: phone, streetName: address.streetName, city: address.city, country: address.country) { [weak self] isSucceeded in
            guard let self = self else{return}
            HandelConnection.handelConnection.checkNetworkConnection { isConn in
                if isConn{
                    if isSucceeded{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showLocationAlert(text: "something went wrong, may be address already added")
                    }
                }else{
                    self.showLocationAlert(text: "Please check your internet connection..")
                }
            }
        }
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
