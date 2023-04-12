//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 27.03.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
}
