//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 02.06.2023.
//

import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    var delegate: SplashViewController?

    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/users/\(username)?client_id=\(accessKey)")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small.absoluteString
                
                completion(.success(self.avatarURL!))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": userResult.profileImage.small.absoluteString])
            case .failure(let error):
                completion(.failure(error))
                DispatchQueue.main.async {
                    self.delegate?.showAlert()
                }
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
