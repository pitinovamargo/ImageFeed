//
//  Constants.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 23.05.2023.
//

import Foundation

let fileAccessKey = "5damU5G0-RGi6CU4KhEzI8_i7VSBJa3wEYGxz1rnl3k"
let fileSecretKey = "lptYM12dkL3rU_-DW9DOXHm9JOhROw4xVvfZ4ZkCybk"
let fileRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let fileAccessScope = "public+read_user+write_likes"

let fileDefaultBaseURL = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: fileAccessKey,
                                     secretKey: fileSecretKey,
                                     redirectURI: fileRedirectURI,
                                     accessScope: fileAccessScope,
                                     defaultBaseURL: fileDefaultBaseURL,
                                     authURLString: unsplashAuthorizeURLString)
        }
}
