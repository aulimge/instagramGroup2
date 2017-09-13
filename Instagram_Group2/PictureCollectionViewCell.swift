//
//  PictureCollectionViewCell.swift
//  Instagram_Group2
//
//  Created by Habib Zarrin Chang Fard on 12/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import SDWebImage

class PictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoURL = post?.imageURL{
            imageView.sd_setImage(with: URL(string: photoURL))
        }
    }
    
    
}
