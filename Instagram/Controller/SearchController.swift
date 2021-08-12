//
//  SearchController.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import  UIKit

private let reuseIdentifier = "UserCell"

class SearchController : UITableViewController {
    
    //MARK: - Properties
    
    private var users = [User]()
    private var filteredUser = [User]()
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
       configureTableView()
        fetchUsers()
       
        
    }
    
    //MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation  = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}



//MARK: - TableView Data source

extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUser.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
    }
}

//MAR: - UITABLEVIEW DELEGATE

extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }

        filteredUser = users.filter({
            $0.userName.contains(searchText) ||
                $0.fullname.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
    }
}
