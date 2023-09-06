//
//  ArticleCell.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 01/09/23.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleTimeLbl: UILabel!
    @IBOutlet weak var articleSourceLbl: UILabel!
    @IBOutlet weak var articleTitleLbl: UILabel!
    @IBOutlet weak var articleImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(article: Article) {
        articleImg.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(systemName: ""))
        articleImg.layer.cornerRadius = 10.0
        articleTitleLbl.text = article.title
        articleSourceLbl.text = article.source?.name
        articleTimeLbl.text = article.publishedAt
        self.contentView.layer.cornerRadius = 10.0
        
        let dateFormater = DateFormatter()
        let date = dateFormater.date(from: article.publishedAt ?? "")
        
        articleTimeLbl.text = date?.timeAgoDisplay()
        print(date?.timeAgoDisplay())
    }
    
}
