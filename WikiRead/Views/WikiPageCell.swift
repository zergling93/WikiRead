//
//  WikiPageCell.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class WikiPageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageImageView: UIImageView!
    
    var page:WikiPage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageImageView.clipsToBounds = true
        self.pageImageView.layer.cornerRadius = 6
        
    }
    func prepareCell() -> Void{
        self.titleLabel.text = self.page.title
        self.descriptionLabel.text = self.page.pageDescription
        if let url = page.image{
            self.pageImageView.sd_setImage(with: URL.init(string:url) , placeholderImage: UIImage.init(named: "wiki"))
        }else{
            self.pageImageView.image = UIImage.init(named: "wiki")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
