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
        viewModel = ContentViewModel(w3wAPI: mockAPI)
        viewModel.threeWordAddress = "filled.count.soap"

        let expectation = self.expectation(description: "Lookup address should succeed")

        // Act
        viewModel.lookupAddress(context: mockContext)

        // Assert
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.resultAddress, "opposite.words.here")
            XCTAssertFalse(self.viewModel.showAlert)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
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
        DispatchQueue.main.async {
            XCTAssertTrue(self.viewModel.showAlert)
            XCTAssertEqual(self.viewModel.errorMessage, "No words returned from the API")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)

    }

    func testFetchLanguagesSuccess() {
        // Arrange
        let mockAPI = MockWhat3WordsAPI()
        let expectedLanguages = [
            W3WBaseLanguage(locale: "de", name: "German", nativeName: "Deutsch"),
            W3WBaseLanguage(locale: "es", name: "Spanish", nativeName: "Español")
        ]
        mockAPI.languagesResponse = (expectedLanguages, nil)
        viewModel = ContentViewModel(w3wAPI: mockAPI)

        let expectation = self.expectation(description: "Wait for fetching languages")

        // Act
        viewModel.fetchLanguagesAvailable()

        // Assert
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.languages, expectedLanguages)
            XCTAssertFalse(self.viewModel.showAlert)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchLanguagesAvailable_Error() {
        // Arrange
        let mockAPI = MockWhat3WordsAPI()
        viewModel = ContentViewModel(w3wAPI: mockAPI)
        let errorResponse = W3WError.code(404, "Test Error")

        mockAPI.languagesResponse = (nil, errorResponse)

        let expectation = self.expectation(description: "Wait for fetch to complete")

        // Act
        viewModel.fetchLanguagesAvailable()

        // Use async delay to ensure the fetch operation has time to complete
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert
        XCTAssertTrue(viewModel.showAlert)

        if let errorMessage = viewModel.errorMessage {
            XCTAssertTrue(errorMessage.contains("Unable to load Language"))
        } else {
            XCTFail("Error message was nil")
        }
    }

    func testPerformanceExample() throws {
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
        self.measure {
            viewModel.lookupAddress(context: mockContext)
        }
    }
}

extension W3WBaseLanguage: Equatable {
    public static func == (lhs: W3WBaseLanguage, rhs: W3WBaseLanguage) -> Bool {
        return lhs.code == rhs.code &&
                       lhs.locale == rhs.locale &&
                       lhs.name == rhs.name &&
                       lhs.nativeName == rhs.nativeName
    }
}
