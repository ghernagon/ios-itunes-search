//
//  iTunes_Search_APIUITests.swift
//  iTunes Search APIUITests
//
//  Created by Gerardo Hernández González on 22-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import XCTest

class iTunes_Search_APIUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() {
        let app = XCUIApplication()
        app.launch()
        
        // Given
        let searchBar = app.searchFields["Buscar"].tap()
        app.searchFields["Buscar"].typeText("Welcome to the jungle")
        let searchButton = app.buttons["Search"].tap()
        
        // Then
    }
    
    func testSelectSearchResult() {
        let app = XCUIApplication()
        app.launch()
        
        // Given
        let searchBar = app.searchFields["Buscar"].tap()
        app.searchFields["Buscar"].typeText("Welcome to the jungle")
        let searchButton = app.buttons["Search"].tap()
                
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Greatest Hits"]/*[[".cells.staticTexts[\"Greatest Hits\"]",".staticTexts[\"Greatest Hits\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testSelectedSong() {
        let app = XCUIApplication()
        app.launch()
        
        // Given
        let searchBar = app.searchFields["Buscar"].tap()
        app.searchFields["Buscar"].typeText("Welcome to the jungle")
        let searchButton = app.buttons["Search"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Greatest Hits"]/*[[".cells.staticTexts[\"Greatest Hits\"]",".staticTexts[\"Greatest Hits\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let selectedResultTitle = app.staticTexts["Greatest Hits"]
        let selectedResultArtist = app.staticTexts["Guns N' Roses"]
        
        let selectedResultTrack1 = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Welcome to the Jungle"]/*[[".cells.staticTexts[\"Welcome to the Jungle\"]",".staticTexts[\"Welcome to the Jungle\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let selectedResultTrack2 = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Sweet Child O' Mine"]/*[[".cells.staticTexts[\"Sweet Child O' Mine\"]",".staticTexts[\"Sweet Child O' Mine\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let selectedResultTrack3 = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Patience"]/*[[".cells.staticTexts[\"Patience\"]",".staticTexts[\"Patience\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        app.tables.cells.containing(.staticText, identifier:"Welcome to the Jungle").buttons["play.fill"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["pause.fill"]/*[[".cells.buttons[\"pause.fill\"]",".buttons[\"pause.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
