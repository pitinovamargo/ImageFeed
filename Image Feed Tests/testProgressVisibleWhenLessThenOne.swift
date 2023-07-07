//
//  testProgressVisibleWhenLessThenOne.swift
//  Image Feed Tests
//
//  Created by Margarita Pitinova on 13.06.2023.
//

@testable import ImageFeed
import XCTest

final class testProgressVisibleWhenLessThenOne: XCTestCase {
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
}
