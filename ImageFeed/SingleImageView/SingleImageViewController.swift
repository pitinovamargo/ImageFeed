//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 16.05.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            imageView.image = image
        }
}
