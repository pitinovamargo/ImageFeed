//
//  testProgressHiddenWhenOne.swift
//  Image Feed Tests
//
//  Created by Margarita Pitinova on 13.06.2023.
//

@testable import ImageFeed
import XCTest

final class testProgressHiddenWhenOne: XCTestCase {
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper() //Dummy
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
}
