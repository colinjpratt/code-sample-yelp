//
//  ViewController.swift
//  yelp-sample-app
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import UIKit

protocol ResultsViewable: AnyObject{
    func displayError(_ errorText: String)
    func reload()
}

class ViewController: UIViewController, ResultsViewable {
    
    @IBOutlet weak var tableView: UITableView?
    private var searchBar: UISearchBar!
    
    private var presenter: Searchable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(with: self, service: APIManager())
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        searchBar.delegate = self
        tableView?.tableHeaderView = searchBar
    }
    
    func displayError(_ errorText: String) {
        let alerView = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerView.addAction(okayAction)
        self.present(alerView, animated: true, completion: nil)
    }
    
    func reload() {
        self.tableView?.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter.search(text)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Show detail view?
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfResults()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as! ResultsTableViewCell
        cell.result = presenter.result(for: indexPath)
        return cell
    }
}

