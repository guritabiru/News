//
//  ArticleDetailVC.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 05/09/23.
//

import UIKit
import SDWebImage
import SafariServices

class ArticleDetailVC: UIViewController {

    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleTItleLbl: UILabel!
    @IBOutlet weak var articleSourceLbl: UILabel!
    @IBOutlet weak var articleDescriptionLbl: UITextView!
    @IBOutlet weak var readMoreBtn: UIButton!
    
    var articleData = Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.setNeedsLayout()
        }
    }
    private func setupView() {
        articleImg.sd_setImage(with: URL(string: articleData.urlToImage ?? ""))
        articleImg.layer.cornerRadius = 10.0
        articleImg.layer.masksToBounds = true
        articleTItleLbl.text = articleData.title
        articleSourceLbl.text = articleData.source?.name != nil ? "by \(articleData.source?.name ?? "")" : ""
        articleDescriptionLbl.text = articleData.description
        articleDescriptionLbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        readMoreBtn.isEnabled = articleData.url != nil ? true : false
    }

    @IBAction func readMoreBtnTapped(_ sender: Any) {
        if let url = URL(string: articleData.url ?? "") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
