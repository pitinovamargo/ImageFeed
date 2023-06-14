//
//  WebViewPresenterSpy.swift
//  Image Feed Tests
//
//  Created by Margarita Pitinova on 13.06.2023.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
} 
