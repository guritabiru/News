//
//  BookmarkVC.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 12/09/23.
//

import UIKit
import RxSwift

class BookmarkVC: BaseParentTabBarVC {

    @IBOutlet weak var bookmarkTableView: UITableView!
    
    let bookmarkViewModel = BookmarkViewModel()
    let disposeBag = DisposeBag()
    private var bookmarkArticlesData = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bookmarkViewModel.getBookmarkedArticles()
        
    }
    
    override func setupView() {
        let bookmarkNib = UINib(nibName: "ArticleCell", bundle: nil)
        bookmarkTableView.register(bookmarkNib, forCellReuseIdentifier: "articleCell")
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
        bookmarkTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    override func setupBinding() {
        bookmarkViewModel
            .successGetBookmarkedArticles
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { articles in
                self.bookmarkArticlesData = articles
                self.bookmarkTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func goToDetail(article: Article) {
        let articleDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailVC
        articleDetailView.articleData = article
        self.navigationController?.pushViewController(articleDetailView, animated: true)
    }

}

extension BookmarkVC: ArticleDetailVCDelegate {
    func updateBookmark() {
        bookmarkViewModel.getBookmarkedArticles()
    }
}

extension BookmarkVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkArticlesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bookmarkTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell else {return UITableViewCell()}
        
        cell.configureCell(article: bookmarkArticlesData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetail(article: bookmarkArticlesData[indexPath.row])
    }
    
    
}
