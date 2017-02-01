//
//  PhotoTableViewCell.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var photo: UIImageView!
    
    var product: Product? {
        didSet {
            guard let string = product?.image, let url = URL(string: string) else { return }
            photo.af_setImage(withURL: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
