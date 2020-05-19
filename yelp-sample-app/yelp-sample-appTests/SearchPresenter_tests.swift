//
//  SearchPresenter_tests.swift
//  yelp-sample-appTests
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import XCTest
import CoreLocation

@testable import yelp_sample_app

class MockView: ResultsViewable {
    var expectations: XCTestExpectation!
    var reloadCalled: Bool = false
    var errorCalled: Bool = false
    
    func displayError(_ errorText: String) {
        errorCalled = true
        expectations.fulfill()
    }
    
    func reload() {
        reloadCalled = true
    }
}

class MockService: APIRequestable {
    var locationService: Locatable?
    
    var delegate: APIResponceDisplayable?
    
    func requestSearch(for text: String) throws -> URLSessionDataTask {
        let dummyTask = URLSessionDataTask()
        return dummyTask
    }
}

class MockLocation: Locatable {
    func start() {
        
    }
    
    var currentLocation: CLLocationCoordinate2D?
    
    var locationUpdate: ((CLLocationCoordinate2D) -> ())?
    
}

class SearchPresenter_tests: XCTestCase {

    var presenter: SearchPresenter!
    var service: MockService!
    var location: MockLocation!
    var view: MockView!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        view = MockView()
        service = MockService()
        location = MockLocation()
        service.locationService = location
        presenter = SearchPresenter(with: view, service: service)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReload() {
        // When
        view.expectations = self.expectation(description: "Async Call")
        presenter.responseRecieved(.success(nil))
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssert(view.reloadCalled)
    }
    
    func testError() {
        func testReload() {
            // When
            view.expectations = self.expectation(description: "Async Call")
            let error = NSError(domain: "test", code: 09, userInfo: nil)
            presenter.responseRecieved(.failure(error))
            
            // Then
            waitForExpectations(timeout: 1)
            XCTAssert(view.errorCalled)
        }
    }
}
