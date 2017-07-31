//
//  UserTableViewCell.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

	// MARK: - Outlets
	
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userReputationLabel: UILabel!
	
	
	// MARK: - Configuration
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
    }

	
	func configure(with user: User) {
		userNameLabel.text = user.displayName
		userReputationLabel.text = "\(user.reputation)"
		
		userImageView.image = #imageLiteral(resourceName: "default_profile")
		if let url = URL(string: user.profileImageURL) {
			NetworkManager().getImage(url: url, completion: { [weak self] (image) in
				DispatchQueue.main.async {
					self?.userImageView.image = image ?? #imageLiteral(resourceName: "default_profile")
				}
			})
		}
	}
	
}
