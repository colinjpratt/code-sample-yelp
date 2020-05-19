//
//  SearchResult.swift
//  yelp-sample-app
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import UIKit

struct ResultsContainer: Codable {
    var businesses: [SearchResult]
}

struct SearchResult: Codable {
    var name: String?
    var rating: Double?
    var phoneNumber: String?
    var imageURLString: String?
    var distance: Double?
    
    enum Keys: String, CodingKey {
        case name
        case rating
        case phoneNumber = "phone"
        case imageURLString = "image_url"
        case distance
    }

    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: Keys.self)
        self.name = try response.decode(String.self, forKey: .name)
        self.rating = try response.decode(Double.self, forKey: .rating)
        self.phoneNumber = try response.decode(String.self, forKey: .phoneNumber)
        self.imageURLString = try response.decode(String.self, forKey: .imageURLString)
        self.distance = try response.decode(Double.self, forKey: .distance)
    }

    func displayableRating() -> String {
        guard let rating = self.rating else {
            return ""
        }
        return "\(rating) star(s)"
    }
    
    func displayableDistance() -> String {
        guard let distance = self.distance else {
            return ""
        }
        return "\(distance) away"
    }
    
}
