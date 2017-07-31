//
//  UserTableViewCell.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userReputationLabel: UILabel!
	
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	
	func configure(with user: User) {
		userNameLabel.text = user.displayName
		userReputationLabel.text = "\(user.reputation)"
	}
	
}
