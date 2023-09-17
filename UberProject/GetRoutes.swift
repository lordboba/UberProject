//
//  GetRoutes.swift
//  UberProject
//
//  Created by Guest User on 9/16/23.
//

import Foundation


func fetchRoutes(orgLat: Float, orgLong: Float, desLat: Float, desLong: Float)-> [String: Any]  {
    let json: [String:Any] = [
                                 "origin":
                                     [
                                         "location":
                                             [
                                                 "latLng":
                                                     [
                                                         "latitude": orgLat,
                                                         "longitude": orgLong
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
                                                         "longitude": desLong
                                                     ]
                                             ]
                                     ],
                                 "travelMode": "TRANSIT",
    //                             "routingPreference": "TRAFFIC_AWARE",
                                 "computeAlternativeRoutes": true,
                                 "routeModifiers":
                                    [
                                     "avoidTolls": false,
                                     "avoidHighways": false,
                                     "avoidFerries": false
                                    ],
                                 "languageCode": "en-US",
                                 "units": "IMPERIAL",
                                 "transitPreferences":
                                    [
    //                                 "routingPreference": "LESS_WALKING|FEWER_TRANSFERS",
                                     "allowedTravelModes": ["BUS","SUBWAY","TRAIN","LIGHT_RAIL","RAIL"]
                                    ],
    //                             "departureTime": "2023-10-15T15:01:23.045123456Z",
                                 ]
    let jsonData: [String:Any] = fetch(json: json)
    return jsonData
}

func fetchRoutes(orgAdd: String, desAdd: String)-> [String: Any]  {
    let json: [String:Any] = [
                             "origin":
                                [
                                 "address": orgAdd
                                ],
                             "destination":
                                [
                                 "address": desAdd
                                ],
                             "travelMode": "TRANSIT",
//                             "routingPreference": "TRAFFIC_AWARE",
                             "computeAlternativeRoutes": true,
                             "routeModifiers":
                                [
                                 "avoidTolls": false,
                                 "avoidHighways": false,
                                 "avoidFerries": false
                                ],
                             "languageCode": "en-US",
                             "units": "IMPERIAL",
                             "transitPreferences":
                                [
//                                 "routingPreference": "LESS_WALKING|FEWER_TRANSFERS",
                                 "allowedTravelModes": ["BUS","SUBWAY","TRAIN","LIGHT_RAIL","RAIL"]
                                ],
//                             "departureTime": "2023-10-15T15:01:23.045123456Z",
                             ]
    let jsonData: [String:Any] = fetch(json: json)
    return jsonData
}

func fetch(json: [String:Any]) -> [String:Any] {
    guard let url = URL(string: "https://routes.googleapis.com/directions/v2:computeRoutes") else {return ["error": "temp"]}
    var request = URLRequest(url:url)
    request.httpMethod = "POST"
    let jsonData = try! JSONSerialization.data(withJSONObject: json)
    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
       print(JSONString)
    }
    request.httpBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
    request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", forHTTPHeaderField: "X-Goog-Api-Key")
    request.setValue("routes.*", forHTTPHeaderField: "X-Goog-FieldMask")
    var the_error = ""
    var jsonResult = [String:Any]()
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            the_error =  error!.localizedDescription
            return
        }
        do {
            print(data)
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : [Any]]
        } catch {
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    if the_error != "" {
        return ["error": the_error]
    }
    if jsonResult.isEmpty {
        return ["error": "Could not find any routes"]
    }
    return jsonResult
}
