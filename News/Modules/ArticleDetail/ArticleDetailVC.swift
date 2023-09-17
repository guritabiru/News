//
//  ArticleDetailVC.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 05/09/23.
//

import UIKit
import SDWebImage
import SafariServices
import RxSwift

protocol ArticleDetailVCDelegate {
    func updateBookmark()
}

class ArticleDetailVC: BaseParentTabBarVC {

    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleTItleLbl: UILabel!
    @IBOutlet weak var articleSourceLbl: UILabel!
    @IBOutlet weak var articleDescriptionLbl: UITextView!
    @IBOutlet weak var readMoreBtn: UIButton!
    
    var articleData = Article()
    let articleDetailViewModel = ArticleDetailViewModel()
    let dispose = DisposeBag()
    var delegate: ArticleDetailVCDelegate?
    
    var isBookmark: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.setNeedsLayout()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateBookmark()
    }
    
    override func setupView() {
        articleImg.sd_setImage(with: URL(string: articleData.urlToImage ?? ""))
        articleImg.layer.cornerRadius = 10.0
        articleImg.layer.masksToBounds = true
        articleTItleLbl.text = articleData.title
        articleSourceLbl.text = articleData.source?.name != nil ? "by \(articleData.source?.name ?? "")" : ""
        articleDescriptionLbl.text = articleData.description
        articleDescriptionLbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        readMoreBtn.isEnabled = articleData.url != nil ? true : false
        
    }
    
    override func setupBinding() {
        articleDetailViewModel
            .successBookmarkArticle
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                print("success bookmark")
                self.isBookmark = true
            })
            .disposed(by: dispose)
        
        articleDetailViewModel
            .isBookmarked
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isBookmarked in
                self.setupBookmarkBarItem(value: isBookmarked)
            })
            .disposed(by: dispose)
        
        articleDetailViewModel.getBookmark(title: articleData.title ?? "")
    }
    
    @objc func bookmarkArticle() {
        if (!isBookmark) {
            articleDetailViewModel.saveArticle(article: articleData)
        } else {
            articleDetailViewModel.deleteArticle(title: articleData.title ?? "")
        }
    }
    
    private func setupBookmarkBarItem(value: Bool) {
        self.isBookmark = value
        let bookmark = UIBarButtonItem(image: UIImage(systemName: value ? "bookmark.fill" : "bookmark") , style: .plain, target: self, action: #selector(bookmarkArticle))
        navigationItem.rightBarButtonItems = [bookmark]
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
