//
//  iTunes_Search_API_Async_Tests.swift
//  iTunes Search API Async Tests
//
//  Created by Gerardo Hernández González on 22-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import XCTest
@testable import iTunes_Search_API

// MARK: - Mocks
class SpyDelegate: NetworkManagerDelegate {
    
    var result: [Song]?
    var resultError: Error?
    
    var promise: XCTestExpectation?
    
    func didSearchMusic(musicData: [Song]) {
        guard let expectation = promise else {
            XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        result = musicData
        expectation.fulfill()
    }
    
    func didFailWithError(error: Error) {
        guard let expectation = promise else {
            XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        resultError = error
        expectation.fulfill()
    }
}

class MockUserDefaults: UserDefaults {
    var mockSearchSaved: [String : Any]?
    override func set(_ value: Any?, forKey defaultName: String) {
        mockSearchSaved = ["date": 12345678, "term": defaultName]
    }
}

// MARK: - Init
class iTunes_Search_API_Async_Tests: XCTestCase {
    
    var sut: ViewController!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as! ViewController
        _ = sut.view
        mockUserDefaults = MockUserDefaults()
        sut.networkManager.localDataManager.userDefaults = MockUserDefaults()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testSUTCanBeInstantiated() {
     
        XCTAssertNotNil(sut)
    }
  
    // MARK: - API
    func testCallToAPICompletesWithNoError() {
        // given
        let spyDelegate = SpyDelegate()
        sut.networkManager.delegate = spyDelegate
        
        let promise = expectation(description: "iTunes API result")
        spyDelegate.promise = promise
        
        // when
        sut.networkManager.searchMusic(by: "Welcome to the jungle", andLimitTo: 2)
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertNil(spyDelegate.resultError, "Search got an error \(spyDelegate.resultError!.localizedDescription)")
        }
    }
    
    func testCallToAPIBringResults() {
        // given
        let spyDelegate = SpyDelegate()
        sut.networkManager.delegate = spyDelegate
        
        let promise = expectation(description: "iTunes API result")
        spyDelegate.promise = promise
        
        // when
        sut.networkManager.searchMusic(by: "Welcome to the jungle", andLimitTo: 2)
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertNotNil(spyDelegate.result, "Expected to have search results")
            XCTAssertNil(spyDelegate.resultError, "Search got an error \(spyDelegate.resultError!.localizedDescription)")
            XCTAssertEqual(spyDelegate.result?.count, 2, "Didn't receive expected results")
        }
    }
    
    // MARK: - Performance
    func testPerformanceAPI() {
        measure {
            sut.networkManager = NetworkManager()
            sut.networkManager.searchMusic(by: "Welcome to the jungle", andLimitTo: 2)
        }
    }

    // MARK: - SearchBar
    func testSUTHasSearchBar() {
        XCTAssertNotNil(sut.searchBar)
    }
    
    func testSUTShouldSetSearchBarDelegate() {
        XCTAssertNotNil(sut.searchBar.delegate)
    }
    
    func testConformsToSearchBarDelegateProtocol() {
        XCTAssert(sut.conforms(to: UISearchBarDelegate.self))
        XCTAssertTrue(sut.responds(to: #selector(sut.searchBarTextDidBeginEditing(_:))))
        XCTAssertTrue(sut.responds(to: #selector(sut.searchBarSearchButtonClicked(_:))))
        XCTAssertTrue(sut.responds(to: #selector(sut.searchBarCancelButtonClicked(_:))))
    }
    
    // MARK: - LocalStorage
    func testSearchTermIsStoredLocally() {
        // given
        let spyDelegate = SpyDelegate()
        sut.networkManager.delegate = spyDelegate
        
        let promise = expectation(description: "Search data stored locally")
        spyDelegate.promise = promise
        
        let mockUD = sut.networkManager.localDataManager.userDefaults as! MockUserDefaults
        
        sut.networkManager.searchMusic(by: "Welcome to the jungle", andLimitTo: 1)
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        
            XCTAssertEqual(mockUD.mockSearchSaved!["term"] as! String, "searchData_Welcome to the jungle", "search term wasn't stored or not found")
            
        }
    }
}
