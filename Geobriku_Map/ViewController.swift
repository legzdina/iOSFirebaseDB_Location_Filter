//
//  ViewController.swift
//  Geobriku_Map
//
//  Created by Kristine Legzdina on 16/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class ViewController: UIViewController, MKMapViewDelegate,secondControllerDelagate {
    
    @IBOutlet weak var mapView: MKMapView!
     let regionInMeters: Double = 150000
    
     let firebaseControllerHandler: FirebaseController = FirebaseController()

    var objects = [Place]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(false, forKey: "switch1")
        UserDefaults.standard.set(false, forKey: "switch2")
        
        mapView.delegate = self
        returnData()
        checkLocationAuthorization()
        
        let point1 = Place(title: "Akmens_tilts", discipline: "Rigas labumi", coordinate: CLLocationCoordinate2D(latitude:56.95823443930545, longitude: 24.142812723536736))
       
        let point2 = Place(title: "Limbažu_Parks", discipline: "Nelielai atputai", coordinate: CLLocationCoordinate2D(latitude:57.5146586, longitude: 24.7131536))
       
        let point3 = Place(title: "Madonas_Parks", discipline: "", coordinate: CLLocationCoordinate2D(latitude:56.8517467, longitude: 26.2184769))
        
        objects.append(contentsOf:[point1,point2,point3])
        mapView.addAnnotations(objects)
    }
    
    func returnData(){
        firebaseControllerHandler.retrieveData("Place") { [unowned self] locations in
            self.mapView.addAnnotations(locations)
            self.objects.append(contentsOf: locations)
        }
    }
    
    func enableFilterKm(dist: Bool) {
        
        if dist == true {
            let myLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
            
            for locations in objects{
                let pinLocation = CLLocation(latitude: locations.coordinate.latitude,longitude: locations.coordinate.longitude)
                let distance = myLocation.distance(from: pinLocation) / 1000
                if (distance > 10){
                    mapView.removeAnnotation(locations)
                    let removeOverlay = mapView.overlays
                    mapView.removeOverlays(removeOverlay)
                }else{}
            }
        }else{
            mapView.addAnnotations(objects)
        }
    }
    
    func enableFilterDesc(noDes: Bool) {
        
        if noDes == true{
            
            for locations in objects{
                if(locations.discipline == ""){
                    mapView.removeAnnotation(locations)
                }else{ }
            }
        }else{
            mapView.addAnnotations(objects)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterIdent" {
            let del : SecondViewController = segue.destination as! SecondViewController
            del.delegate = self
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Place"
        if annotation is Place {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            }else{
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Place
        let placeName = location.title
        let description = location.discipline
        let ac = UIAlertController(title: placeName, message: description, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Show Route", style: .default, handler: {(ac:UIAlertAction!) in self.pressed(view: view)}))
        present(ac,animated: true, completion: nil)
    }
    
    func pressed(view: MKAnnotationView){
        if let annotation = view.annotation{
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(0, 0)))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            let directions = MKDirections(request: request)
            directions.calculate{ response, error in
                if let route = response?.routes.first {
                    self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        }else{}
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 2
        return renderer
    }

}
extension ViewController: CLLocationManagerDelegate{
}


