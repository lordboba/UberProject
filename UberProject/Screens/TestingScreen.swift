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
        // = fetchRoutes(orgAdd: "1665 E 7th St, Brooklyn, NY 11230", desAdd: "93-02 69th Ave, Queens, NY 11375")
        //print(routes)
        print("\n--------------------------------------\n")
        routes = fetchRoutes(orgAdd: "Portland, Oregon", desAdd: "Chicago, Illinois")
        var route_list = routes["routes"] as! [Any]
        for r in route_list {
            var steps = (((route_list[1] as! Dictionary<String, Any>)["legs"] as! [Any])[0] as! Dictionary<String, Any>)["steps"] as! [Any]
            for s in steps {
                var temp2 = s as! Dictionary<String, Any>
                var instruction_text = (s as! Dictionary<String, Any>)["navigationInstruction"] as! Dictionary<String, String>
                //print(s)
                var mode = temp2["travelMode"] as! String
                //var details = (s as! Dictionary<String, Any>)["transitDetails"] as! Dictionary<String, Any>
                var vals = (s as! Dictionary<String, Any>)["localizedValues"] as! Dictionary<String, Any>

                //print(details)
                print(mode)
                if (temp2.contains { $0.key == "transitDetails" }) {
                    print("yes transit")
                }
                print(instruction_text)
                print(vals)
                //print(type(of:s))

            }
            //print(temp)
            //var keys = (temp as! Dictionary<String, Any>).keys
            //print(type(of:temp))
            //print(temp["legs"])
            //print(keys)

        }
//        print(route_list.count)
//        print(route_list[0])
//        var json = [Any]()
//        for r in route_list {
//            var route = [String:Any]()
//            route["localizedValues"] = (r as! [String:Any])["localizedValues"]
//
//        }
        // Do any additional setup after loading the view.
        print("****************")
//        print(route_list)
//        do {
//            // here jsonData is the dictionary encoded in JSON data
//            let jsonData:Data = try JSONSerialization.data(
//                withJSONObject: route_list,
//                options: .prettyPrinted
//            )
//
//            // get a JSON string from jsonData object
//            let jsonString:String = String(data: jsonData, encoding: .utf8)!
//            print(jsonString)
//        } catch {
//            print(error.localizedDescription)
//        }
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
