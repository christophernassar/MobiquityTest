//
//  HomeViewController.swift
//  mobiquityTest
//
//  Created by Christopher Nassar on 07/07/2021.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchtableView: UITableView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak private var historyTableViewHeightConstraint: NSLayoutConstraint!
    
    private var refreshControl = UIRefreshControl()
    private var homeViewModel = HomeViewModel() //View model instance
    
    // Used for scrollView
    var lastContentOffset: CGFloat = 0
    var currentPage = 0
    var items: [Photo]?
    
    var eligibleForLoadMore: Bool {
        return !(items?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureViewModel()
    }

    //Configure table view
    private func configureTableView(){
        refreshControl.accessibilityIdentifier = UIAccessibilityIdentifiers.refreshControlAccessiblity
        refreshControl.attributedTitle = NSAttributedString(string: UIStrings.refreshControlTitle)
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        searchtableView.refreshControl = refreshControl
        
        searchtableView.tableFooterView = UIView() // Remove empty cells
        searchtableView.registerCell(type: FlickrSearchCell.self)// Register cell for table view
        searchtableView.rowHeight = 150
        
        historyTableView.tableFooterView = UIView() // Remove empty cells
        historyTableView.registerCell(type: HistoryCell.self)// Register cell for table view
        historyTableView.rowHeight = 50
    }
    
    @objc private func refreshAction() {
        currentPage = 0
        search()
    }
    
    //Configure view model
    private func configureViewModel(){
        //Define the behaviors when block is called from view-model
        
        homeViewModel.startAnimating = { [weak self] in
            self?.toggleLoaders(false)
        }
        
        homeViewModel.stopAnimating = { [weak self] in
            DispatchQueue.main.async {
                self?.toggleLoaders(true)
            }
        }
        
        homeViewModel.populateListing = {[weak self] (results: Any) in
            guard let self = self,
                  let photos = (results as? SearchFlickrModel)?.photos?.photo else { return }
            self.currentPage == 0 ? self.items = photos : (self.items! += photos)
            self.currentPage += 1
            DispatchQueue.main.async {
                self.searchtableView.reloadData()
            }
        }
        
        homeViewModel.errorUI = {[weak self] (response:String) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIHelper.displayDialog(title: UIStrings.genericErrorTitle, message: response, cntrl: self)
            }
        }
    }
    
    private func toggleLoaders(_ hide: Bool) {
        hide ? self.refreshControl.endRefreshing() : self.refreshControl.beginRefreshing()
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currentPage = 0
        search()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        refreshHistoryTableView()
    }
    
    func refreshHistoryTableView() {
        guard let history = CachingHelper.getKeywords() else { return }
        historyTableViewHeightConstraint.constant = CGFloat(history.count) * historyTableView.rowHeight
        historyTableView.isHidden = false
    }
    
    func search() {
        guard let text = searchBar.text,
              !text.isEmpty else {
            toggleLoaders(true)
            return
        }
        
        viewModelSearch(keyword: text, page: currentPage)
    }
    
    func viewModelSearch(keyword: String, page: Int) {
        CachingHelper.storeKeyword(keyword)
        historyTableView.isHidden = true
        searchBar.resignFirstResponder()
        homeViewModel.searchImage(keyword: keyword, page: page)
    }
}
