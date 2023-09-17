//
//  GooglePlacesManager.swift
//  UberProject
//
//  Created by Tyler Xiao on 9/16/23.
//

import Foundation
import GooglePlaces

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    public func setUp() {
        GMSPlacesClient.provideAPIKey((Bundle.main.infoDictionary?["API_KEY"] as? String)!)
    }
    
    public func findPlaces(
        query: String,
        completion: @escaping (Result<[String], Error>) -> Void) {
            
    }
}
