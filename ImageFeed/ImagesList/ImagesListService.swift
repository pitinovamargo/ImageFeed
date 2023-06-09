//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 07.06.2023.
//

import UIKit

final class ImagesListService {
    
    // отправляется запрос для получения страницы с фотографиями;
    // сохраняется номер последней скачанной страницы;
    // после того как скачивание страницы завершено, по необходимости (например, пользователь дошёл до конца списка) отправляется запрос на скачивание следующей страницы.
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = [] // тут храним список уже скачанных фотографий
    private var lastLoadedPage: Int? = nil // тут будем хранить номер последней скачанной страницы
    private var isFetching = false
    private var currentPage = 1
    private let itemsPerPage = 10
    // ...
    
    func fetchPhotosNextPage() { // тут получаем очередную страницу, скачивать больше одной страницы за раз не будем; если идёт закачка — будем отправлять новый запрос только после её завершения.
        guard !isFetching else { return }
        isFetching = true
        
        // Simulating network request delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let url = URL(string: "https://api.unsplash.com/photos?page=\(self.currentPage)&per_page=\(self.itemsPerPage)") else {
                self.isFetching = false
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self, let data = data else {
                    self?.isFetching = false
                    return
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
                            isLiked: photoResult.liked_by_user
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: newPhotos)
                        NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                        self.isFetching = false
                        self.currentPage += 1
                        self.lastLoadedPage = self.currentPage - 1
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    self.isFetching = false
                }
            }
            task.resume()
        }
    }
    private func dateFromString(_ dateString: String) -> Date? {
            let dateFormatter = ISO8601DateFormatter()
            return dateFormatter.date(from: dateString)
        }
}

struct Photo { // инфа о полученных фото для описания отдельного экземпляра фотографии
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
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
    // Other properties if needed
}
