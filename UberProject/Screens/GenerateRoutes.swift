//
//  GenerateRoutes.swift
//  UberProject
//
//  Created by Emma Shen on 9/17/23.
//

import UIKit
import CoreLocation
import MapKit
class GenerateRoutes: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // How many rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    //Defines what cells are being used
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        //print("bleh")
        cell.configure(modeIcons: modeIcons[indexPath.row], times: times[indexPath.row], prices: prices[indexPath.row], emissions: emissions[indexPath.row])
        return cell
    }
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet var sortButtons: [UIButton]!
    
    @IBAction func sortByAction(_ sender: Any) {
        showButtonVisibility()
    }
    
    @IBAction func sortButtonsAction(_ sender: UIButton) {
        showButtonVisibility()
//        print((sender.titleLabel!.text)!)
        switch (sender.titleLabel!.text)! {
        case "Time":
            sortByButton.backgroundColor = .systemBlue
            sortByButton.setTitle("Time", for: .normal)
        case "Price":
            sortByButton.backgroundColor = .systemYellow
            sortByButton.setTitle("Price", for: .normal)
        case "Emissions":
            sortByButton.backgroundColor = .systemGreen
            sortByButton.setTitle("Emissions", for: .normal)
        default:
            sortByButton.backgroundColor = .systemBlue
            sortByButton.setTitle("Time", for: .normal)
        }
    }
    // Generate certain icons depending on route
    let modeIcons: [UIImage] = [UIImage(named: "Bus.png")!, UIImage(named: "Car.png")!, UIImage(named: "Train.png")!, UIImage(named: "Subway.png")!, UIImage(named: "Light-rail.png")!]
    
    // Need to connect to backend
    var times: [String] = ["35", "65", "32", "12", "123"]
    var prices: [String] = ["55", "45", "97", "13", "34"]
    var emissions: [String] = ["4", "53", "34", "23", "16"]
    var coords : CLLocationCoordinate2D!
    var curr_loc : CLLocationCoordinate2D!
    var locationManager = CLLocationManager()

  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        semaphore.signal()
        curr_loc = locValue
        var routeCoords = fetchRoutes(orgLat: Float(curr_loc.latitude), orgLong: Float(curr_loc.longitude), desLat: Float(coords.latitude), desLong: Float(coords.longitude))
        locationManager.stopUpdatingLocation()
        if(routeCoords.keys.contains("error")) {
            return
        } else {
            createTable(routeCoords: routeCoords["routes"] as! [Any])
        }
        //createTable(routeCoords: routeCoords)
        //print(bob)
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func createTable(routeCoords : [Any]) {
        var dex = 0
        for r in routeCoords{
            var actual = r as! Dictionary<String,Any>
            var the_time = (Float((actual["duration"] as! String).components(separatedBy: "s")[0]+".0") ?? 0.0) / 60.0
            let roundedTime = round(the_time * 10) / 10.0
            times[dex] = String(roundedTime)
            print(the_time)
            dex = dex + 1
        }
    }
    var semaphore : DispatchSemaphore!
    override func viewDidLoad() {
        super.viewDidLoad()
        semaphore = DispatchSemaphore(value: 0)

        locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                    print("xuan")
                }
        //semaphore.wait()
        //print(curr_loc)
        //semaphore.wait()
        //var bob = fetchRoutes(orgLat: Float(curr_loc.latitude), orgLong: Float(curr_loc.longitude), desLat: Float(coords.latitude), desLong: Float(coords.longitude))
        //print(bob)
        
        print("yo")
    }

    func showButtonVisibility () {
        print("on/off")
        sortButtons.forEach {button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
}
