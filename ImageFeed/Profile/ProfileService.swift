//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 01.06.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private var profile: Profile?
    
    private var lastToken: String?
    private let lock = NSLock()
    private let semaphore = DispatchSemaphore(value: 0)
    
    func fetchProfile(_ token: String) {
        self.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.lock.unlock()
                self.semaphore.signal()
            case .failure(let error):
                self.lastToken = nil
                self.lock.unlock()
                self.semaphore.signal()
                fatalError("ERROR: \(error)")
            }
        }
    }
    
    func getProfile() -> Profile? {
        if self.profile == nil {
            self.semaphore.wait()
        }
        return self.profile
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        lock.lock()
        lastToken = token
        
        let url = URL(string: "https://api.unsplash.com/me")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                let profile = Profile(username: profileResult.username, name: "\(profileResult.firstName) \(profileResult.lastName)", loginName: "@\(profileResult.username)", bio: profileResult.bio ?? "")
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}
