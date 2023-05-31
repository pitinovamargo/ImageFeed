//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 29.05.2023.
//

import Foundation

class OAuth2Service {
    
    private var lastCode: String?
    private var currentTask: URLSessionTask?
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code
        
        let request = makeRequest(code)
        callUnsplash(request: request) { (result: Result<Data, Error>)  in
            let parsed = result.flatMap { data -> Result<String, Error> in
                Result{ try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data).accessToken }
            }
            completion(parsed)
        }
    }
    
    private func makeRequest(_ code: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    private func callUnsplash(
        request: URLRequest,
        responseHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    responseHandler(.success(data))
                }
                self.currentTask = nil
                if let error = error {
                    responseHandler(.failure(NetworkError.urlRequestError(error)))
                    self.lastCode = nil
                }
                if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= responseCode {
                    } else {
                        responseHandler(.failure(NetworkError.httpStatusCode(responseCode)))
                        self.lastCode = nil
                    }
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
}
