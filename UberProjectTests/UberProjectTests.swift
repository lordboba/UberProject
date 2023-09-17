//
//  UberProjectTests.swift
//  UberProjectTests
//
//  Created by Tyler Xiao on 9/16/23.
//

import XCTest
@testable import UberProject

final class UberProjectTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchRoutes() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        var routes = [String: Any]()
        routes = UberProject.fetchRoutes(orgLat: 37.419734, orgLong: -122.0827784, desLat: 37.417670, desLong: -122.079595)
        print(routes)
        var check = Array(routes.keys)[0]
        XCTAssert(check != "error")
        
        routes = UberProject.fetchRoutes(orgAdd: "1600 Amphitheatre Parkway, Mountain View, CA", desAdd: "450 Serra Mall, Stanford, CA 94305, USA")
        print(routes)
        check = Array(routes.keys)[0]
        XCTAssert(check != "error")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
