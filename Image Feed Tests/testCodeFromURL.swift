//
//  testCodeFromURL.swift
//  Image Feed Tests
//
//  Created by Margarita Pitinova on 13.06.2023.
//

@testable import ImageFeed
import XCTest

final class testCodeFromURL: XCTestCase {
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}

