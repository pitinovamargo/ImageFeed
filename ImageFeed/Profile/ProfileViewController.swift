//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 13.04.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        let profileImage = profileImage()
        let userName = userName()
        let nikname = nikname()
        let profileDescription = profileDescription()
        let logoutButton = logoutButton()
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nikname.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            nikname.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            profileDescription.topAnchor.constraint(equalTo: nikname.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
    }
    
    func profileImage() -> UIImageView {
        let profileImage = UIImageView(image: UIImage(named: "ProfilePhoto"))
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        return profileImage
    }
    
    func userName() -> UILabel {
        let userName = UILabel()
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.textColor = .ypWhite
        userName.text = "Екатерина Новикова"
        userName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        return userName
    }
    
    func nikname() -> UILabel {
        let nikname = UILabel()
        view.addSubview(nikname)
        nikname.translatesAutoresizingMaskIntoConstraints = false
        nikname.textColor = .ypGray
        nikname.text = "@ekaterina_nov"
        nikname.font = UIFont.systemFont(ofSize: 13)
        
        return nikname
    }
    
    func profileDescription() -> UILabel {
        let profileDescription = UILabel()
        view.addSubview(profileDescription)
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        profileDescription.textColor = .ypWhite
        profileDescription.text = "Hello, world!"
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        
        return profileDescription
    }
    
    func logoutButton() -> UIButton {
        let logoutButton = UIButton()
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(named: "Logout Button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        return logoutButton
    }


}
