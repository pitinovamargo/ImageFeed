//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 02.06.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        //        let urlString = "https://api.unsplash.com/users/\(username)?client_id=\(accessKey)"
        
        let url = URL(string: "https://api.unsplash.com/users/\(username)?client_id=\(accessKey)")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(String(describing: OAuth2TokenStorage().token))", forHTTPHeaderField: "Authorization")
        
        //        guard let url = URL(string: urlString) else {
        //            completion(.failure(ProfileImageError.invalidURL))
        //            return
        //        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("ошибка первая")
                return
            }
            
            guard let data = data else {
                completion(.failure(ProfileImageError.noData))
                print("ошибка вторая")
                
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userResult = try decoder.decode(UserResult.self, from: data)
                self.avatarURL = userResult.profileImage.small.absoluteString
                print("ошибочка третья")
                
                completion(.success(self.avatarURL!))
            } catch {
                completion(.failure(error))
                print(error)
                
            }
        }
        
        task.resume()
    }
}


struct UserResult: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: URL
        
        enum CodingKeys: String, CodingKey {
            case small
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

enum ProfileImageError: Error {
    case invalidURL
    case noData
}
