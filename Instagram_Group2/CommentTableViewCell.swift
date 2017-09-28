//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by Wei Liang on 1/20/17.
//  Copyright © 2017 Wei Liang. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: Contact? {
        didSet {
            updateUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView() {
        commentLabel.text = comment?.commentText
        
    }
    
    func updateUserInfo() {
        nameLabel.text = user?.username
        if let photoURL = user?.imageURL {
            profileImageView.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(named: "profile"))
        }
    }
    
    // flush the user profile image before a reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "profile")
    }

}
