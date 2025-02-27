//
//  TodoCaseStudyIOSUITests.swift
//  TodoCaseStudyIOSUITests
//
//  Created by Luca Argentino on 27.02.2025.
//

import XCTest


final class CreateTodoIOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func test_create_shouldCreateTodoSuccessfully() throws {
        throw XCTSkip()
        let app = XCUIApplication()
        app.launch()
        
        // GIVEN
        let createTodoTab = app.tabBars.buttons["create_todo"]
        let titleTextField = app.textFields["title"]
        let dueDatePicker = app.datePickers.element
        let priorityWheel = app.pickers.element
        let wheel = priorityWheel.pickerWheels.element
        

        // WHEN
        createTodoTab.tap()
        
        titleTextField.tap()
        titleTextField.typeText("Seperate Busniess Logic")
        app.keyboards.buttons["Return"].tap()
        
        dueDatePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "April")
        dueDatePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "15")
        dueDatePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2025")

        wheel.adjust(toPickerWheelValue: "High")
        
        app.buttons["Save"].tap()
        
        // THEN
        XCTAssertTrue(app.collectionViews.cells.count > 0)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
