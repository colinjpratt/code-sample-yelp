//
//  File.swift
//  yelp-sample-app
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import Foundation

protocol Searchable: AnyObject {
    func search(_ text: String)
    func numberOfResults() -> Int
    func result(for indexPath: IndexPath) -> SearchResult
}

class SearchPresenter: Searchable {
    
    private weak var view: ResultsViewable?
    
    private var api: APIRequestable?
    private var currentRequest: URLSessionDataTask?
    private var results: [SearchResult] = []
    
    init(with view: ResultsViewable, service: APIRequestable) {
        let location = LocationService()
        location.start()
        
        
        self.view = view
        self.api = service
        
        api?.locationService = location
        api?.delegate = self
    }
    
    func search(_ text: String) {
        currentRequest?.cancel()
        do {
            currentRequest = try api?.requestSearch(for: text)
        } catch {
            view?.displayError(error.localizedDescription)
        }
    }
    
    func numberOfResults() -> Int {
        return results.count
    }
    
    func result(for indexPath: IndexPath) -> SearchResult{
        return results[indexPath.row]
    }
}

extension SearchPresenter: APIResponceDisplayable {
    func responseRecieved(_ result: Result<[SearchResult]?, Error>) {
        switch result {
        case .success(let results):
            self.results = results ?? []
            DispatchQueue.main.async {
                self.view?.reload()
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
}
