//
//  HomeVC.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 29/08/23.
//

import UIKit
import RxSwift

class HomeVC: BaseParentTabBarVC {

    @IBOutlet weak var topNewsCollectionView: UICollectionView!
    @IBOutlet weak var recommendedTableView: UITableView!
    
    private let homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    private var topNewsData = [Article]()
    private var recommendedNewsData = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupView()
        homeViewModel.requestTopNews()
        homeViewModel.requestRecommended()
    }
    
    override func setupBinding() {
        homeViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { error in
                switch error {
                case .internetError(let message):
                    print(message)
                case .serverMessage(let message):
                    print(message)
                }
            })
            .disposed(by: disposeBag)
        
        homeViewModel
            .topNews
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { articles in
                self.topNewsData = articles
                self.topNewsCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        homeViewModel
            .recommendedNews
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { articles in
                self.recommendedNewsData = articles
                self.recommendedTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func setupView() {
        let recommendedNib = UINib(nibName: "ArticleCell", bundle: nil)
        recommendedTableView.register(recommendedNib, forCellReuseIdentifier: "articleCell")
        recommendedTableView.dataSource = self
        recommendedTableView.delegate = self
        recommendedTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        let topNewsNib = UINib(nibName: "TopNewsCell", bundle: nil)
        topNewsCollectionView.register(topNewsNib, forCellWithReuseIdentifier: "topNewsCell")
        topNewsCollectionView.dataSource = self
        topNewsCollectionView.delegate = self
        
    }
    
    private func goToDetail(article: Article) {
        let articleDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailVC
        articleDetailView.articleData = article
        self.navigationController?.pushViewController(articleDetailView, animated: true)
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedNewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recommendedTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell else {return UITableViewCell()}
        
        cell.configureCell(article: recommendedNewsData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetail(article: recommendedNewsData[indexPath.row])
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNewsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = topNewsCollectionView.dequeueReusableCell(withReuseIdentifier: "topNewsCell", for: indexPath) as? TopNewsCell else {return UICollectionViewCell()}
        
        cell.configureCell(article: topNewsData[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToDetail(article: topNewsData[indexPath.row])
    }
}
