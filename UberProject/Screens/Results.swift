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

// this file is responsible for showing out location predictions
class Results: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // instance of delegate
    weak var delegate: ResultsDelegate?
    
    // this is where the location predictions are shown
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor  = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // lay out the tableview
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // update function
    public func update(with places: [Place]) {
        // rows are unhidden
        self.tableView.isHidden = false
        self.places = places
        print(places.count)
        tableView.reloadData()
    }
    
    // return number of rows to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    // sets the row to the name of the location
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }

    // called when user selects a row. finds the coordinates of the place
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // hide all the rows once one is selected
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
