//
//  NetworkServiceTests.swift
//  MobiquityTestTests
//
//  Created by Christopher Nassar on 10/07/2021.
//

import XCTest
@testable import MobiquityTest

/// Network service unit testing
class NetworkServiceTests: XCTestCase {
    let service = NetworkService()
    
    // Test if the server host is reachable
    func test_givenValidHostExists_dataIsReturned() {
        let expectation = self.expectation(description: "resource")
        
        var resourceData: Data?
        var resourceError: Error?
        
        let str = ServiceHelper.serverHost
        let request = Request(urlRequest: URLRequest(url: URL(string: str)!))
        
        service.get(request: request) { (result) in
            switch result {
            case .success(let data):
                resourceData = data
            case .failure(let error):
                resourceError = error
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(resourceError)
        XCTAssertNotNil(resourceData)
    }
    
    // Test if the server host is not reachable, and error will return
    func test_givenInValidHostExists_errorIsReturned() {
        let expectation = self.expectation(description: "resource")
        
        var resourceData: Data?
        var resourceError: Error?
        
        let request = Request(urlRequest: URLRequest(url: URL(string: "https://www.blahblah.com")!))
        
        service.get(request: request) { (result) in
            switch result {
            case .success(let data):
                resourceData = data
            case .failure(let error):
                resourceError = error
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(resourceData)
        XCTAssertNotNil(resourceError)
    }
    
    // Test the sanity of the data returned from the most viewed API
    func test_checkDataSanity() {
        let expectation = self.expectation(description: "data resource")
        MockService().searchImages(keyword: "home") { (success, data) in
            if success{
                XCTAssertNotNil(data as? SearchFlickrModel)
            }else{
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}


/// Mocking classes
private class MockService: FlickrServiceInterface {
    
}
