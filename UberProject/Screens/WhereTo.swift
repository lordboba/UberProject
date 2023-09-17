//
//  ViewController.swift
//  UberProject
//
//  Created by Tyler Xiao on 9/16/23.
//

import UIKit
import MapKit

class WhereTo: UIViewController, UISearchResultsUpdating {

    let mapView = MKMapView()
    
    let searchVC = UISearchController(searchResultsController: Results())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Where to?"
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width,
            height: view.frame.size.height - view.safeAreaInsets.top
        )
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? Results else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case.success(let places):
                
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
                
                
            case.failure(let error):
                print(error)
            }
        }
    }

}

extension WhereTo: ResultsDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D){
        
        // keyboard go away after find destination
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        // remove past map pins
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // add a map pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinates,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2
                )),
            animated: true
        )
    }
}

