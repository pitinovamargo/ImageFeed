//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 07.06.2023.
//

import UIKit

final class ImagesListService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = [] // тут храним список уже скачанных фотографий
    private var lastLoadedPage: Int? = nil // тут будем хранить номер последней скачанной страницы
    private var isFetching = false
    private var currentPage = 1
    private let itemsPerPage = 10
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return }
        isFetching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIBlockingProgressHUD.show()
            guard let url = URL(string: "https://api.unsplash.com/photos?page=\(self.currentPage)&per_page=\(self.itemsPerPage)"),
                  let token = OAuth2TokenStorage().token else {
                self.isFetching = false
                return
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    
                    guard let self = self, let data = data else {
                        self?.isFetching = false
                        return
                    }
                    if let error = error {
                        print("Error fetching photos: \(error)")
                        UIBlockingProgressHUD.dismiss()
                        return
                    }
                    if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                        if 200..<300 ~= responseCode {
                        } else {
                            print("Error response while fetching photos: \(responseCode)")
                            UIBlockingProgressHUD.dismiss()
                            return
                        }
                    }
                    do {
                        let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                        let newPhotos = photoResults.map { photoResult in
                            return Photo(
                                id: photoResult.id,
                                size: CGSize(width: photoResult.width, height: photoResult.height),
                                createdAt: self.dateFromString(photoResult.created_at),
                                welcomeDescription: photoResult.description,
                                thumbImageURL: photoResult.urls.thumb,
                                largeImageURL: photoResult.urls.regular,
                                fullImageUrl: photoResult.urls.full,
                                isLiked: photoResult.liked_by_user
                            )
                        }
                        self.photos.append(contentsOf: newPhotos)
                        NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                        self.isFetching = false
                        self.currentPage += 1
                        self.lastLoadedPage = self.currentPage - 1
                        UIBlockingProgressHUD.dismiss()
                    } catch {
                        print("Error decoding JSON: \(error)")
                        self.isFetching = false
                    }
                }
            }
            task.resume()
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage().token else { return }
        
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= responseCode {
                } else {
                    completion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            }
            completion(.success(()))
        }
        
        task.resume()
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: dateString)
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let fullImageUrl: String
    var isLiked: Bool
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let created_at: String
    let updated_at: String
    let width: Int
    let height: Int
    let color: String
    let blur_hash: String
    let likes: Int
    let liked_by_user: Bool
    let description: String?
    let urls: UrlsResult
}
