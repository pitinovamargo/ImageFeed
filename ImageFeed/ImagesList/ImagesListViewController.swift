//
//  ViewController.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 20.03.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"

    @IBOutlet weak private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == ShowSingleImageSegueIdentifier { // 1
               let viewController = segue.destination as! SingleImageViewController // 2
               let indexPath = sender as! IndexPath // 3
               let image = UIImage(named: photosName[indexPath.row]) // 4
               viewController.image = image // 5
           } else {
               super.prepare(for: segue, sender: sender) // 6
           }
       }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        if let image = UIImage(named: "\(indexPath.row)") {
            cell.cellImage.image = image
        } else {
            return
        }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = UIImage(named: "Red Like")
        } else {
            cell.likeButton.imageView?.image = UIImage(named: "White Like")
        }
        
    }
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: "\(indexPath.row)") else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}
