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
        self.profileService.delegate = self
        self.profileImageService.delegate = self
        
        if let token = OAuth2TokenStorage().token {
            self.profileService.fetchProfile(token)
            self.profileImageService.fetchProfileImageURL(username: profileService.getProfile()?.username ?? "") { _ in }
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: "AuthViewSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AuthViewSegue" {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Can not find AuthViewController") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
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
                self.profileImageService.fetchProfileImageURL(username: self.profileService.getProfile()?.username ?? "") { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                print("Failed: \(error)")
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
                break
            }
        }
    }
}

extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(
            title: "Alert title",
            message: "Alert message",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
