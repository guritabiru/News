//
//  TopNewsCell.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 01/09/23.
//

import UIKit
import SDWebImage

class TopNewsCell: UICollectionViewCell {

    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsSourceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(article: Article) {
        newsImg.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(systemName: ""))
        newsImg.layer.cornerRadius = 10.0
        newsTitleLbl.text = article.title
        newsSourceLbl.text = article.source?.name
    }

}
