//
//  Results.swift
//  UberProject
//
//  Created by Tyler Xiao on 9/16/23.
//

import UIKit
import CoreLocation
protocol ResultsDelegate: AnyObject {
    func didTapPlace(with coordinates: CLLocationCoordinate2D)
}

// Showing location predictions
class Results: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Instance of delegate
    weak var delegate: ResultsDelegate?
    
    // Location predictions shown through table format
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var places: [Place] = []
    
    // Add tableView as subview
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor  = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Adjust frame of tableView to fill out entire bounds of 'Results' view controller's view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // Update palces property & reload data in table
    public func update(with places: [Place]) {
        // rows are unhidden
        self.tableView.isHidden = false
        self.places = places
        print(places.count)
        tableView.reloadData()
    }
    
    // Return number of rows to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    // Sets the row to the name of the location
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }

    // Called when user selects a row. Finds the coordinates of the place
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Hide all the rows once one is selected
        tableView.isHidden = true
        
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case.success(let coordinate):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: coordinate)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
