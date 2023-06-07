//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 29.05.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let splashScreenLogo = splashScreenLogo()
        NSLayoutConstraint.activate([
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let token = OAuth2TokenStorage().token {
            self.profileService.fetchProfile(token)
            self.profileImageService.fetchProfileImageURL(username: profileService.getProfile()?.username ?? "") { result in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                case .success(_):
                    DispatchQueue.main.async {
                        self.switchToTabBarController()
                    }
                }
            }
        } else {
            print("MOVING TO AUTH VIEW")
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func acceptToken(code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service().fetchAuthToken(code) { result in
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
                self.profileService.fetchProfile(accessToken)
                self.profileImageService.fetchProfileImageURL(username: self.profileService.getProfile()?.username ?? "") { result in
                    switch result {
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    case .success(_):
                        DispatchQueue.main.async {
                            UIBlockingProgressHUD.dismiss()
                            self.switchToTabBarController()
                        }
                    }
                }
            case .failure(let error):
                print("Failed: \(error)")
                UIBlockingProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.showAlert()
                }
                break
            }
        }
    }
}

extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func splashScreenLogo() -> UIImageView {
        let splashScreenLogo = UIImageView(image: UIImage(named: "Logo_of_Unsplash"))
        view.addSubview(splashScreenLogo)
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        
        return splashScreenLogo
    }
}
