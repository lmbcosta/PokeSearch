//
//  ViewController.swift
//  PokeSearch
//
//  Created by Luis  Costa on 03/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import MapKit
import GeoFire

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var pokemons = [String: Int]()
    var isFirstUserUpdate = true
    var geoFire: GeoFire!
    var geoFireReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Geofire
        geoFireReference = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireReference)
        
        // Delegates
        locationManager.delegate = self
        mapView.delegate = self
        
        mapView.userTrackingMode = .followWithHeading
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Fire initial functions
        initializePokemons()
        authorizeStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        authorizeStatus()
    }
    
    private func authorizeStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func createSightinnPokemon(forLocation location: CLLocation, withName name: String) {
        geoFire.setLocation(location, forKey: name)
    }
    
    private func showSightsOnMap(atLocation location: CLLocation) {
        let query = geoFire.query(at: location, withRadius: 2)
        
        // GeoFireQuery
        _ = query?.observe(.keyEntered, with: { (key, location) in
            guard let key = key, let location = location else {return}
            guard let id = self.pokemons[key] else {return}
            
            let annotation = PokemonAnnotation(id: id, title: key, coordinate: location.coordinate)
            self.mapView.addAnnotation(annotation)
        })
    }
    
    
    
    private func initializePokemons() {
        guard let path = Bundle.main.path(forResource: "pokemon", ofType: "csv") else {return}

        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let id = Int(row["id"]!)
                let name = row["identifier"]!.capitalized
                
                pokemons[name] = id
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    @IBAction func pokemonBallPressed(_ sender: Any) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let names = Array(pokemons.keys)
        let index = Int(arc4random_uniform(UInt32(names.count)))
        let randomPokemonName = names[index]
        
        createSightinnPokemon(forLocation: location, withName: randomPokemonName)
    }
}

// MARK: - Extensions
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        let identifier = "Pokemon"
        
        if annotation.isKind(of: MKUserLocation.self) {
            if let image = UIImage(named: "ash") {
                annotationView = MKAnnotationView()
                annotationView?.image = image
            }
        } else if let dequeueAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeueAnnotation
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let pokemonAnnotation = annotation as? PokemonAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(pokemonAnnotation.id)")
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(UIImage(named: "map") , for: .normal)
            annotationView.rightCalloutAccessoryView = button
        }
        
       return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if isFirstUserUpdate {
            let coordinate = userLocation.coordinate
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
            mapView.setRegion(coordinateRegion, animated: true)
            isFirstUserUpdate = false
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        // To show pokemons in different regions when user drag on the map
        showSightsOnMap(atLocation: location)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PokemonAnnotation {
            let placeMark = MKPlacemark(coordinate: annotation.coordinate)
            let destination = MKMapItem(placemark: placeMark)
            destination.name = "Pokemon Sighting"
            //destination.name = view.annotation.
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(annotation.coordinate, regionDistance, regionDistance)
            
            let options: [String: Any] = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
        
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
            
    }
        
}














