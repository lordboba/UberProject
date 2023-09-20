//
//  GooglePlacesManager.swift
//  UberProject
//
//  Created by Tyler Xiao on 9/16/23.
//

import Foundation
import GooglePlaces
import CoreLocation

// Create model
struct Place {
    let name: String
    let identifier: String
}

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    // Get client for Google Places
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    // Create custom error
    enum PlacesError: Error {
        case failedToFind
        case failedToGetCoordinates
    }
    
    
    // Fetching all places, autocomplete for certain query
    public func findPlaces(
        
        query: String,
        completion: @escaping (Result<[Place], Error>) -> Void
    ) {
        //print(GMSPlacesClient.provideAPIKey(Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""))
        //print(type(of: client))
            let filter = GMSAutocompleteFilter()
        filter.types = ["geocode"]
        client.findAutocompletePredictions(
                fromQuery: query,
                filter: filter,
                sessionToken: nil
            ) { results, error in
                // Unwrap
                guard let results = results, error == nil else {
                    //print("up")
                    //print(results)
                    completion(.failure(PlacesError.failedToFind))
                    return
                }
                // Use results to create an array of place models
                let places: [Place] = results.compactMap({
                    Place(
                        name: $0.attributedFullText.string,
                        identifier: $0.placeID
                    )
                })
                
                // Call completion handler
                completion(.success(places))
            }
    }
    
    //Converting that place to a given field
    public func resolveLocation(
        for place: Place,
        // CLLocation encapsulates both longitude and latitude
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ) {
        client.fetchPlace(
            fromPlaceID: place.identifier,
            placeFields: .coordinate,
            sessionToken: nil
        ) { googlePlace, error in
            // Unwrap
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            
            let coordinate = CLLocationCoordinate2D(
                latitude: googlePlace.coordinate.latitude,
                longitude: googlePlace.coordinate.longitude
            )

            completion(.success(coordinate))
        }
    }
}
