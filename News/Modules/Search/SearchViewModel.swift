//
//  SearchViewModel.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 07/09/23.
//

import Foundation
import RxSwift
import Alamofire

class SearchViewModel {
    
    public var searchResult: PublishSubject<[Article]> = PublishSubject()
    public var loadMoreResult: PublishSubject<[Article]> = PublishSubject()
    private var page = 1
    
    public func requestSearchArticle(query: String, isLoadMore: Bool = false) {
        page += isLoadMore ? 1 : 0
        let param = [
            "apiKey": Credentials.apiKey,
            "pageSize": "20",
            "language": "en",
            "q": query,
            "page": String(describing: page)
        ]
        
        AF.request("\(Endpoints.baseUrl)\(Endpoints.everythingNews)",
                   method: .get,
                   parameters: param
        ).responseJSON(completionHandler: { response in
            guard let data = response.data else {return}
            guard let request = response.request?.url else {return}
            do {
                let searchResult = try JSONDecoder().decode(Response.self, from: data)
                if (isLoadMore) {
                    self.loadMoreResult.onNext(searchResult.articles ?? [])
                } else {
                    self.searchResult.onNext(searchResult.articles ?? [])
                }
            } catch {
                
            }
        })
    }
}
