//
//  HomeViewModel.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 01/09/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

struct HomeViewModel {
    public enum homeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let topNews: PublishSubject<[Article]> = PublishSubject()
    public let recommendedNews: PublishSubject<[Article]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error: PublishSubject<homeError> = PublishSubject()
    
    public func requestTopNews() {
        self.loading.onNext(true)
        let param = [
            "apiKey": "c6eded46100e4bcfabd1890750d17250",
            "pageSize": "6",
            "language": "en"
        ]
        AF.request("https://newsapi.org/v2/top-headlines", method: .get,
                   parameters: param
        ).responseJSON(completionHandler: { response in
            guard let data = response.data else {return}
            do {
                let topNews = try JSONDecoder().decode(Response.self, from: data)
                self.topNews.onNext(topNews.articles ?? [])
            } catch {
                
            }
        })
        
    }
    
    public func requestRecommended() {
        self.loading.onNext(true)
        let param = [
            "apiKey": "c6eded46100e4bcfabd1890750d17250",
            "pageSize": "3",
            "country": "us",
            "page": "2"
        ]
        AF.request("https://newsapi.org/v2/top-headlines", method: .get,
                   parameters: param
        ).responseJSON(completionHandler: { response in
            guard let data = response.data else {return}
            do {
                let recommendedNews = try JSONDecoder().decode(Response.self, from: data)
                self.recommendedNews.onNext(recommendedNews.articles ?? [])
            } catch {
                
            }
        })
    }
}
