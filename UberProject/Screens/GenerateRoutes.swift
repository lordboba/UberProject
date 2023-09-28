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
    // Defines what cells are being used
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        //print("bleh")
        cell.configure(modeIcons: icons[indexPath.row], times: times[indexPath.row], prices: prices[indexPath.row], emissions: emissions[indexPath.row])
        return cell
    }
    
    // Connection to frontend Storyboard objects
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet var sortButtons: [UIButton]!
    
    @IBAction func sortByAction(_ sender: Any) {
        showButtonVisibility()
    }
    
    // Update optimal routes based on user request of sorting filter
    @IBAction func sortButtonsAction(_ sender: UIButton) {
        showButtonVisibility()
//        print((sender.titleLabel!.text)!)
        switch (sender.titleLabel!.text)! {
        case "Time":
            sortByButton.backgroundColor = .systemBlue
            sortByButton.setTitle("Time", for: .normal)
            sortBy(array:times,dir:true)

        case "Price":
            sortByButton.backgroundColor = .systemYellow
            sortByButton.setTitle("Price", for: .normal)
            sortBy(array:prices,dir:true)

        case "Emissions":
            sortByButton.backgroundColor = .systemGreen
            sortByButton.setTitle("Emissions", for: .normal)
            sortBy(array:emissions,dir:false)

        default:
            sortByButton.backgroundColor = .systemBlue
            sortByButton.setTitle("Time", for: .normal)
            sortBy(array:times,dir:true)
        }
        cardTableView.reloadData()
    }
    
    // Generate car, bus, subway, light rail, and/or train icons depending on modes of transportation used in that particular route
    func sortBy(array : [String], dir : Bool) {
        var actual : [Float] = []
        for a in array {
            actual.append(Float(a)!)
        }
        let size = array.count
            for x in 0..<size{
                for y in 0..<size-x-1 {
                    if actual[y] > actual[y+1] {
                        actual = swapAll(a:y, b:y+1, arr: actual)
                    }
                }
            }
        if !dir {
            reverseAll()
        }
        print(actual)
    }
    func reverseAll() {
        times = times.reversed()
        prices = prices.reversed()
        emissions = emissions.reversed()
        icons = icons.reversed()
    }
    func swapAll(a : Int, b: Int, arr : [Float]) -> [Float]{
        var temp = times[a]
        times[a] = times[b]
        times[b] = temp
        temp = prices[a]
        prices[a] = prices[b]
        prices[b] = temp
        temp = emissions[a]
        emissions[a] = emissions[b]
        emissions[b] = temp
        var temp2 = icons[a]
        icons[a] = icons[b]
        icons[b] = temp2
        var bot = arr
        var temp3 = arr[a]
        bot[a] = arr[b]
        bot[b] = temp3
        return bot
        
    }
    var times: [String] = []
    var prices: [String] = []
    var emissions: [String] = []
    var icons: [[Bool]] = []
    
    // Car, Bus, Subway, Train, Light-rail
    let emitNum : [Float] = [ 377.0,291.0,40.0,177.0,249.5]
    let textVal :[String] = ["DRIVE","BUS","SUBWAY","TRAIN","LIGHT_RAIL"]
    var coords : CLLocationCoordinate2D!
    var curr_loc : CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    
    // Get current location of user to use
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        // Takes 2 parameters (manager for location services, locations array to represent updated location data)
        locations: [CLLocation]) {
        
        // Extract latitute and longitude from most recent location update
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        // Signal completion of asynchronous operation
        semaphore.signal()
        curr_loc = locValue
        var routeCoords = fetchRoutes(orgLat: Float(curr_loc.latitude), orgLong: Float(curr_loc.longitude), desLat: Float(coords.latitude), desLong: Float(coords.longitude))
        locationManager.stopUpdatingLocation()
        
        // ERROR HANDLING
        if(routeCoords.keys.contains("error")) {
            return
        } else {
            createTable(routeCoords: routeCoords["routes"] as! [Any])
        }
        //print(bob)
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func createTable(routeCoords : [Any]) {
        // Add one car only
        var maxEmissions:Float = 0.0
        // Fetch drive route
        var driveRoute = (fetchDriveRoute(orgLat: Float(curr_loc.latitude), orgLong: Float(curr_loc.longitude), desLat: Float(coords.latitude), desLong: Float(coords.longitude)))
        // If returns route key
        if (driveRoute.keys.contains("routes")) {
            var realDrive = (driveRoute["routes"] as! [Any])[0] as! Dictionary<String,Any>
            // Duration (time)
            var the_time = (Float((realDrive["duration"] as! String).components(separatedBy: "s")[0]+".0") ?? 0.0) / 60.0
            let roundedTime = round(the_time * 10) / 10.0
            times.append(String(roundedTime))
            
            // Distance
            var dist = Float((realDrive["localizedValues"] as! Dictionary<String, Dictionary<String, String>>)["distance"]!["text"]!.components(separatedBy: " ")[0])!
            
            // Fare
            var fare = max(7.0, 2.55 + 0.35 * the_time + 1.75 * dist)
            let fareStr = round(the_time * 100) / 100.0
            prices.append(String(fareStr))
            maxEmissions = 371.0 * dist
            emissions.append("0")
            icons.append([true, false, false, false, false])
            //print(fare)
        }
        
        // Refresh displayed info
        cardTableView.reloadData()
        //print(driveRoute)
        var dex = 1
        //go through routes and calculate prices and emissions for New York City Transit
        for r in routeCoords {
            var actual = r as! Dictionary<String,Any>
            var the_time = (Float((actual["duration"] as! String).components(separatedBy: "s")[0]+".0") ?? 0.0) / 60.0
            // Find the total time it takes to complete the route
            let roundedTime = round(the_time * 10) / 10.0
            times.append(String(roundedTime))
            // Estimate the price of public transportation
            var price:Float = 0.0
            var icon_keys = [false, false, false, false, false]
            var emissions:Float = 0.0
            var steps = (((r as! Dictionary<String, Any>)["legs"] as! [Any])[0] as! Dictionary<String, Any>)["steps"] as! [Any]
            for s in steps {
                var temp2 = s as! Dictionary<String, Any>
                var mode = temp2["travelMode"] as! String
                var vals = temp2["localizedValues"] as! Dictionary<String, Dictionary<String, String>>
                // Determine travel mode
                if mode == "TRANSIT" {
                    var type = (((temp2["transitDetails"] as! Dictionary<String, Any>)["transitLine"] as! Dictionary<String,Any>)["vehicle"] as! Dictionary<String, Any>)["type"] as! String
                    //print(type)
                    if type == "HEAVY_RAIL" {
                        type = "TRAIN"
                    }
                    for i in 0..<5 {
                        if(textVal[i] == type) {
                            var dist = Float(vals["distance"]!["text"]!.components(separatedBy: " ")[0])!
                            emissions = emissions + emitNum[i] * dist
                            icon_keys[i] = true
                        }
                    }
                    if type  == "TRAIN"{
                        price += 15.0
                    }else{
                        price += 2.9
                    }//print(vals)
                }
                //print(mode)
                //print(vals)
            }
            price = round(price * 100) / 100.0
            //emissions = round(emissions)
            var percentChange = round((maxEmissions-emissions) / maxEmissions * 100)
            prices.append(String(price))
            self.emissions.append(String(percentChange))
            icons.append(icon_keys)
            //print(price)
            //print(emissions)
            //print(actual)
            //emissions calculations
            //print(the_time)
            dex = dex + 1
        }
        cardTableView.reloadData()
    }
    
    var semaphore : DispatchSemaphore!
    override func viewDidLoad() {
        super.viewDidLoad()
        semaphore = DispatchSemaphore(value: 0)

        // Requests permission for the app to always access the device's location 
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
        //print("yo")
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
