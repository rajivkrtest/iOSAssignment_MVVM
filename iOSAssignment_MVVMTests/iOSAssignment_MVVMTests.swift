//
//  iOSAssignment_MVVMTests.swift
//  iOSAssignment_MVVMTests
//
//  Created by Rajiv Kumar on 08/10/20.
//

import Foundation
import XCTest
@testable import iOSAssignment_MVVM

class iOSAssignment_MVVMTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetFactsWithExpectedURLHostAndPath() {
        let url = URL(string: APIClientConstants.Resource.facts.url)
        XCTAssertEqual(url?.host!, "dl.dropboxusercontent.com")
        XCTAssertEqual(url?.path, "/s/2iodh4vg0eortkl/facts.json")
    }

    func testGetSuccessReturnsFacts() {
        let factsExpectation = expectation(description: "Expecting valid JSON response")
        var factsResponse : FactsResponse? = nil
        APIClient.shared.getFacts(parameters: [:], completion: { (results) in
            if let results = results {
                factsResponse = results
                factsExpectation.fulfill()
            }
        }) { (error) in
            factsExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(factsResponse, "Success Response")
        }
    }
    
    func testGetFactsWhenInvalidURLReturnsError() {
        let errorExpectation = expectation(description: "Expecting invalid response")
        var errorResponse : APIError? = nil
        APIClient.shared.getFactsWithURL(url: "https://dl.dropboxusercontent.com/s1/2iodh4vg0eortkl/facts.json", parameters: [:]) { (results) in
            
        } failure: { (error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse, "Error Response")
        }
    }
    
    func testGetFactsInvalidJSONReturnsError() {
        let errorExpectation = expectation(description: "Expecting JSON data as nil")
        var factsResponse : FactsResponse? = nil
        APIClient.shared.getFactsWithURL(url: "https://dl.dropboxusercontent.com/s1/2iodh4vg0eortkl/facts.json", parameters: [:]) { (results) in
            if let results = results {
                factsResponse = results
                errorExpectation.fulfill()
            } else {
                errorExpectation.fulfill()
            }
        } failure: { (error) in
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(factsResponse)
        }
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
