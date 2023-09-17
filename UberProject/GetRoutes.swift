//
//  GetRoutes.swift
//  UberProject
//
//  Created by Guest User on 9/16/23.
//

import Foundation
func fetchRoutes(orgLat: Float, orgLong: Float, desLat: Float, desLong: Float)-> [String: Any]  {
    guard let url = URL(string: "https://routes.googleapis.com/directions/v2:computeRoutes") else {return ["error": "temp"]}
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
                                 "travelMode": "DRIVE",
                                 "routingPreference": "TRAFFIC_AWARE",
                                 "computeAlternativeRoutes": true,
                                 "routeModifiers": [
                                     "avoidTolls": false,
                                     "avoidHighways": false,
                                     "avoidFerries": false
                                 ],
                                 "languageCode": "en-US",
                                 "units": "IMPERIAL"
//                                 "departureTime": "2023-10-15T15:01:23.045123456Z",
                             ]
    let jsonData = try! JSONSerialization.data(withJSONObject: json)
    request.httpBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
    request.setValue("AIzaSyD1owuZouA8R-YrvpxZStbWT_LrwyaFBYk", forHTTPHeaderField: "X-Goog-Api-Key")
    request.setValue("routes", forHTTPHeaderField: "X-Goog-FieldMask")
    var the_error = ""
    var jsonResult = [String:Any]()
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            the_error =  error!.localizedDescription
            return
        }
        do {
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
