//
//  api-manager.swift
//  yelp-sample-app
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import Foundation

protocol APIRequestable {
    var locationService: Locatable? { get set }
    var delegate: APIResponceDisplayable? { get set }
    func requestSearch(for text: String) throws -> URLSessionDataTask
}

protocol APIResponceDisplayable: AnyObject {
    func responseRecieved(_ result: Result<[SearchResult]?, Error>)
}

enum APIError: Error {
    case URL
    case KEY
    case LOCATION
}

class APIManager: APIRequestable {
    var locationService: Locatable?
    
    private struct APIKey: Codable {
        var key: String?
        var client: String?
        
        enum keys: String, CodingKey {
            case key = "api_key"
            case client = "client_id"
        }
        
        init(from decoder: Decoder) {
            let container = try? decoder.container(keyedBy: keys.self)
            key = try? container?.decode(String.self, forKey: .key)
            client = try? container?.decode(String.self, forKey: .client)
        }
    }
    
    private var baseURL: String = "https://api.yelp.com/v3/businesses/search?"
    
    private lazy var keys: APIKey? = {
        self.loadAuthBearer()
    }()
    
    weak var delegate: APIResponceDisplayable?
    
    // function to read api key from file and store it in ivar for quick access
    private func loadAuthBearer() -> APIKey? {
        if let path = Bundle.main.path(forResource: "api", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let keys = try decoder.decode(APIKey.self, from: data)
                return keys
              } catch {
                // handle error
                print(error)
              }
        }
        return nil
    }
    
    //Make search requests
    func requestSearch(for text: String) throws -> URLSessionDataTask {
        if locationService == nil {
            throw APIError.LOCATION
        }
        
        guard let lat = locationService?.currentLocation?.latitude, let lon = locationService?.currentLocation?.longitude else {
            throw APIError.LOCATION
        }
        
        let urlString = baseURL + "term=\(text)&latitude=\(lat)&longitude=\(lon)"
        guard let url = URL(string: urlString) else {
            throw APIError.URL
        }
        var request = URLRequest(url: url)
        guard let key = keys?.key else {
            throw APIError.KEY
        }
        
        request.addAuthBearer(with: key)
    
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                self?.delegate?.responseRecieved(.failure(error))
            }
            if let data = data, let parsedResult = self?.parse(data) {
                self?.delegate?.responseRecieved(parsedResult)
            }
        }
        task.resume()
        return task
    }
    
    private func parse(_ data: Data) -> Result<[SearchResult]?, Error>{
        do {
            let results = try JSONDecoder().decode(ResultsContainer.self, from: data)
            return .success(results.businesses)
        } catch {
            do {
                let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                return .failure(NSError(domain: errorMessage.code, code: 100, userInfo: ["message": errorMessage.description]))
            } catch {
                return .failure(NSError(domain: "", code: 999, userInfo: nil))
            }
        }
    }
}

private extension URLRequest {
    mutating func addAuthBearer(with key: String) {
        self.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
    }
}
