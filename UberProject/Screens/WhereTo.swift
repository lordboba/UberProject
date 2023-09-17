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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }

    func updateSearchResults(for searchController: UISearchController) {
        
    }

}

