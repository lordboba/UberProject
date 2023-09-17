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
        routes = UberProject.fetchRoutes(orgLat: 40.731181, orgLong: -73.885253, desLat: 40.596178, desLong: 73.980285)
        print(routes)
        var check = Array(routes.keys)[0]
        XCTAssert(check != "error")
        
        routes = UberProject.fetchRoutes(orgAdd: "Humberto Delgado Airport, Portugal", desAdd: "Basílica of Estrela, Praça da Estrela, 1200-667 Lisboa, Portugal")
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
