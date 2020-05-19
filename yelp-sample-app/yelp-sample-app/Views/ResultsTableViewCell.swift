//
//  ResultsTableViewCell.swift
//  yelp-sample-app
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    var result: SearchResult? {
        didSet {
            nameLabel.text = result?.name
            ratingLabel.text = result?.displayableRating()
            distanceLabel.text = result?.displayableDistance()
            self.businessImageView.setImage(urlString: result?.imageURLString)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callBusiness(_ sender: Any) {
        if let number = result?.phoneNumber {
            let callString = "tel://\(number)"
            guard let url = URL(string: callString) else {
                return
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


extension UIImageView {
    func setImage(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage.init(data: data)
                }
            }
        }.resume()
    }
}
