//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 25.05.2023.
//

import UIKit

class AuthViewController: UIViewController {
    let showWebViewIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowWebView" {
            let authView = segue.destination as? WebViewViewController
            if let unwrappedView = authView {
                unwrappedView.delegate = self
            }
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service().fetchAuthToken(code) { result in
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
            case .failure(let error):
                print("Failed: \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

