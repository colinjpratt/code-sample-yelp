//
//  ErrorMessage.swift
//  yelp-sample-app
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import UIKit

struct ErrorMessage: Codable {
    var code: String = ""
    var description: String = ""
    
    enum Keys: String, CodingKey {
        case error
        case code
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let error = try container.nestedContainer(keyedBy: Keys.self, forKey: .error)
        self.code = try error.decode(String.self, forKey: .code)
        self.description = try error.decode(String.self, forKey: .description)
    }
    
}
