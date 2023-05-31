//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 31.05.2023.
//

import UIKit
import ProgressHUD

class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
