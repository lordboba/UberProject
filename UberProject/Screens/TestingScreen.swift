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
        routes = fetchRoutes(orgAdd: "1665 E 7th St, Brooklyn, NY 11230", desAdd: "93-02 69th Ave, Queens, NY 11375")
        print(routes)
        print("\n--------------------------------------\n")
        routes = fetchRoutes(orgAdd: "Portland, Oregon", desAdd: "Chicago, Illinois")
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
