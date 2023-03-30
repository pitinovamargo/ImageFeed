//
//  ViewController.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 20.03.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newLayer = CAGradientLayer()
//        newLayer.colors = [UIColor.ypBlack.cgColor, UIColor.ypBackground.cgColor]
//        newLayer.frame = view.frame
//        view.layer.insertSublayer(newLayer, at: 0)
    }
    
    func configCell(for cell: ImagesListCell) {
        cell.subviews[0].subviews[0]
    }
    
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell)
        return imageListCell
    }
}
