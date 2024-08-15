//
//  ThreeWordsTests.swift
//  ThreeWordsTests
//
//  Created by Kevin on 8/13/24.
//

import XCTest
import CoreLocation
import W3WSwiftApi
@testable import ThreeWords

final class ThreeWordsTests: XCTestCase {
    var viewModel: ContentViewModel!
    var mockAPI: MockWhat3WordsAPI!
    var mockContext: MockContext!

    override func setUp() {
        super.setUp()
        mockAPI = MockWhat3WordsAPI()
        mockContext = MockContext()
        viewModel = ContentViewModel(w3wAPI: mockAPI)
    }

    override func tearDown() {
        super.tearDown()
        mockAPI = nil
        mockContext = nil
        viewModel = nil
    }


    func testInitialState() {
        XCTAssertEqual(viewModel.threeWordAddress, "")
        XCTAssertEqual(viewModel.resultAddress, "")
        XCTAssertTrue(viewModel.historyItems.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showAlert)
    }

    func testLookupAddressSuccess() {
           // Arrange
        let mockAPI = MockWhat3WordsAPI()

        let mockSquare = MockW3WSquare(
            words: "opposite.words.here",
            coordinates: CLLocationCoordinate2D(
                latitude: 51.520847,
                longitude: -0.195521
            )
        )
        mockAPI.convertToCoordinatesResult = (mockSquare, nil)
        mockAPI.convertTo3waResult = (mockSquare, nil)

        let viewModel = ContentViewModel(w3wAPI: mockAPI)

        viewModel.threeWordAddress = "filled.count.soap"

        // Create an expectation
        let expectation = self.expectation(description: "Lookup address should succeed")
        
        // Act
        viewModel.lookupAddress(context: mockContext)
        
        // Wait for the async process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assert
            XCTAssertEqual(viewModel.resultAddress, "opposite.words.here")
            XCTAssertFalse(viewModel.showAlert)
            expectation.fulfill()  // Fulfill the expectation
        }
        
        waitForExpectations(timeout: 5, handler: nil) // Wait for expectations

       }

    func testLookupAddressFailure() {
        let mockAPI = MockWhat3WordsAPI()

        let mockSquare = MockW3WSquare(
            words: "",
            coordinates: CLLocationCoordinate2D(
                latitude: 51.520847,
                longitude: -0.195521
            )
        )
        mockAPI.convertToCoordinatesResult = (mockSquare, nil)
        mockAPI.convertTo3waResult = (mockSquare, nil)

        viewModel = ContentViewModel(w3wAPI: mockAPI)
        viewModel.threeWordAddress = "test.words.here"

        // When
        viewModel.lookupAddress(context: mockContext)
        let expectation = self.expectation(description: "Wait for lookup failure")

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.showAlert)
            XCTAssertEqual(self.viewModel.errorMessage, "No words returned from the API")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
