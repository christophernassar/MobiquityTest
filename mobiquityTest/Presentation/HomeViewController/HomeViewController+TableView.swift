//
//  HomeViewController+TableView.swift
//  MobiquityTest
//
//  Created by Christopher Nassar on 08/07/2021.
//

import UIKit

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchtableView {
            return items?.count ?? 0
        } else {
            return CachingHelper.getKeywords()?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchtableView {
            let cell = tableView.dequeueCell(withType: FlickrSearchCell.self, for: indexPath) as! FlickrSearchCell
            if let item = self.items?[indexPath.row]{
                cell.configureView(imageURL: item.photoURL, title: item.title)
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(withType: HistoryCell.self, for: indexPath) as! HistoryCell
            cell.delegate = self
            if let item = CachingHelper.getKeywords()?[indexPath.row]{
                cell.configureView(keyword: item)
            }
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView != searchtableView { return }
        
        if !eligibleForLoadMore {
            tableView.tableFooterView = UIView()
            return
        }
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
    
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            addLoadMoreSpinner(tableView)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTableView {
            if let keyword = CachingHelper.getKeywords()?[indexPath.row] {
                currentPage = 0
                searchBar.text = keyword
                viewModelSearch(keyword: keyword, page: 0)
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.lastContentOffset > scrollView.contentOffset.y {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height {
                loadMore()
            }
        }

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    private func loadMore() {
        if !eligibleForLoadMore {
            return
        }
        search()
    }
    
    private func addLoadMoreSpinner(_ tableView: UITableView) {
        if let spinner = tableView.tableFooterView as? UIActivityIndicatorView {
            spinner.isHidden = false
        } else {
            let spinner = UIActivityIndicatorView()
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
            spinner.color = .gray
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
    }
}

extension HomeViewController: HistoryCellDelegate {
    func removeKeyword(_ keyword: String) {
        CachingHelper.removeKeyword(keyword)
        refreshHistoryTableView()
    }
}
