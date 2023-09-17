//
//  SearchVC.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 07/09/23.
//

import UIKit
import RxSwift

class SearchVC: BaseParentTabBarVC {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var articlesTableView: UITableView!
    
    let searchViewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    private var articlesData = [Article]()
    
    override func setupView() {
        searchBar.delegate = self
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        let nib = UINib(nibName: "ArticleCell", bundle: nil)
        articlesTableView.register(nib, forCellReuseIdentifier: "articleCell")
    }
    
    override func setupBinding() {
        searchViewModel.searchResult
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { articles in
                self.articlesData = articles
                self.articlesTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        searchViewModel.loadMoreResult
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {articles in
                self.articlesData.append(contentsOf: articles)
                self.articlesTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func goToDetail(article: Article) {
        let articleDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailVC
        articleDetailView.articleData = article
        self.navigationController?.pushViewController(articleDetailView, animated: true)
    }

}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 1){
            self.searchViewModel.requestSearchArticle(query: searchText)
        } else if (searchText.count == 0) {
            articlesData.removeAll()
            articlesTableView.reloadData()
        }
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = articlesTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell else {return UITableViewCell()}
        
        cell.configureCell(article: articlesData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == articlesData.count - 1) {
            searchViewModel.requestSearchArticle(query: searchBar.text ?? "", isLoadMore: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetail(article: articlesData[indexPath.row])
    }
    
}
