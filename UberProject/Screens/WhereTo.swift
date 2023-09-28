//
//  ViewController.swift
//  UberProject
//
//  Created by Tyler Xiao on 9/16/23.
//

import UIKit
import MapKit

// Users search for places & find routes to those places on a map
class WhereTo: UIViewController, UISearchResultsUpdating {

    // Display map
    let mapView = MKMapView()
    
    // Handle user input & display search results
    // Results function is responsible for showing our location predictions
    let searchVC = UISearchController(searchResultsController: Results())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Title which is displayed on the top left
        title = "Where to?"
        // Add map as a subview
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Prevent search bar from overlapping with map
        mapView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width,
            height: view.frame.size.height - view.safeAreaInsets.top
        )
    }

    func updateSearchResults(for searchController: UISearchController) {
        // Get query text out of searchController
        guard let query = searchController.searchBar.text,
              // Can't search for empty string
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? Results else {
            return
        }
        
        resultsVC.delegate = self
        
        // Call API. Find all places for this query and return an array of places back
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case.success(let places):
                
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
                
            case.failure(let error):
                print(error)
                //print("fe")
            }
        }
    }
}

extension WhereTo: ResultsDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D){
        
        // Keyboard go away after find destination
        searchVC.searchBar.resignFirstResponder()
        // Removes cancel button when location is selected
        searchVC.dismiss(animated: true, completion: nil)
        
        // Remove past map pins
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // Add a map pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        
        // Sets map's region to focus on selected place
        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinates,
                span: MKCoordinateSpan( // How far you want to zoom into map
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2
                )),
            animated: true
        )
        let deadline = Date().advanced(by: 1)
        Thread.sleep(until: deadline)
        
        // Create new view controller & passes selected coordinates to it
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateRoutes") as! GenerateRoutes
        vc.coords = coordinates
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
        
    }
}

