//
//  GetRoutes.swift
//  UberProject
//
//  Created by Guest User on 9/16/23.
//

import Foundation
func fetch(orgLat: Float, orgLong: Float, desLat: Float, desLong: Float) {
    guard let url = URL(string: "https://routes.googleapis.com/directions/v2:computeRoutes") else{return}
    var request = URLRequest(url:url)
    request.httpMethod = "POST"
    //replace the oid with temp variable
    let json: [String:Any] = [
                                 "origin":
                                     [
                                         "location":
                                             [
                                                 "latLng":
                                                     [
                                                         "latitude": orgLat,
                                                         "longitute": orgLong
                                                     ]
                                             ]
                                     ],
                                 "destination":
                                     [
                                         "location":
                                             [
                                                 "latLng":
                                                     [
                                                         "latitude": desLat,
                                                         "longitute": desLong
                                                     ]
                                             ]
                                     ],
                                 "travelMode": "BUS",
                                 "routingPreference": "TRAFFIC_AWARE",
                                 "computeAlternativeRoutes": true,
                                 "routeModifiers": [
                                     "avoidTolls": false,
                                     "avoidHighways": false,
                                     "avoidFerries": false
                                 ],
                                 "languageCode": "en-US",
                                 "units": "IMPERIAL",
//                                 "departureTime": "2023-10-15T15:01:23.045123456Z",
                             ]
    let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    request.httpBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("*", forHTTPHeaderField: "Access-Control-Request -Headers")
    request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "X-Goog-Api-Key")
    request.setValue("routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline", forHTTPHeaderField: "X-Goog-FieldMask")
    
    print("gru")

    

    let task = URLSession.shared.dataTask(with: request){ [weak self]
        data, response, error in
        //print("brp")
        //print(data!)
        guard let data = data, error == nil else {
            return
        }
        do{
            //print("dru")
            
            //
            // let data_result = jsonResult as! Dictionary<String,Any>
            let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            //print(jsonResult)
            //let data_ish = try JSONDecoder().decode(DataUpdate.self, from: data)
            //print("chicken?")
            //self?.user_data = jsonResult
            DispatchQueue.main.async {
                self?.user_data = jsonResult as! Dictionary<String,Any>
                //print("yoo")
                self?.processData()
            }
            
            //print(self?.user_data)
            //print(data_ish)
            //print(data_result)
            //var id_var = data_result["document"] as! Dictionary<String,Any>
        }catch{
            print(error)
        }
    }
    task.resume()
}
