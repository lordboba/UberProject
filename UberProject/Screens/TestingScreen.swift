//
//  TestingScreen.swift
//  UberProject
//
//  Created by Guest User on 9/17/23.
//

import UIKit

class TestingScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var routes = [String: Any]()
        routes = fetchRoutes(orgLat: 37.419734, orgLong: -122.0827784, desLat: 37.417670, desLong: -122.079595)
        print(routes)
        print("\n--------------------------------------\n")
        routes = fetchRoutes(orgAdd: "1600 Amphitheatre Parkway, Mountain View, CA", desAdd: "450 Serra Mall, Stanford, CA 94305, USA")
        print(routes)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
