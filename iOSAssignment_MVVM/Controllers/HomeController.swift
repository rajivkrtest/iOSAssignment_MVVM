//
//  HomeController.swift
//  iOSAssignment_MVVM
//
//  Created by Rajiv Kumar on 03/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Kingfisher

class HomeController: RootViewController {
    
    // MARK: - Properties
    var homeItems = [Row]()

    var homeTableView: UITableView!

    var refreshControl = UIRefreshControl()
    
    private var factsViewModel : FactsViewModel!
    
    private var dataSource : FactsTableViewDataSource<HomeTableViewCell, [Row]>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeTableView = UITableView()
        self.homeTableView?.rowHeight = UITableView.automaticDimension
        self.homeTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.homeTableView?.estimatedRowHeight = 100
        self.homeTableView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.homeTableView!)
        self.homeTableView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.homeTableView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.homeTableView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.homeTableView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        self.homeTableView?.register(HomeTableViewCell.self, forCellReuseIdentifier: Constants.kHomeTableViewCell)

        //Add pull to refresh to table view
        self.refreshControl.attributedTitle = NSAttributedString(string: Constants.kPullToRrefresh)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.homeTableView?.addSubview(self.refreshControl)
        
        self.callToViewModelForUIUpdate(string: Constants.kLoading)
        
    }

    @objc func refresh(_ sender: AnyObject) {
        self.callToViewModelForUIUpdate(string: Constants.kRefreshing)
    }
    
    /// Call viewModel to update UI
    ///
    /// - Parameters:
    ///   - string: Message to show in navigation bar title
    func callToViewModelForUIUpdate(string: String){
        
        if NetworkState.isConnected() {
            self.factsViewModel =  FactsViewModel()
            self.title = string
            self.factsViewModel.bindFactsViewModelToController = {
                self.title = ""
                self.refreshControl.endRefreshing()
                if let title = self.factsViewModel.factsData?.title {
                    self.title = title
                }
                self.updateTableViewDataSource()
            }
            
            self.factsViewModel.bindErrorsViewModelToController = {
                if let error:APIError = self.factsViewModel.error {
                    self.displayError(message: error.errorDescription)
                }
            }
        } else {
            self.displayError(message: "No Network Avaliable")
        }
    }
    
    /// Common method to show the alert
    ///
    /// - Parameters:
    ///   - message: Alert body message
    func displayError(message: String) {
        self.title = ""
        let dialogMessage = UIAlertController(title: Constants.kError, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Constants.kDismiss, style: .default, handler: { (action) -> Void in
            self.homeTableView?.reloadData()
            self.refreshControl.endRefreshing()
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func updateTableViewDataSource(){
        if let arr = self.factsViewModel.factsData?.rows {
            self.dataSource = FactsTableViewDataSource(cellIdentifier: Constants.kHomeTableViewCell, items: arr, configureCell: { (cell, fct) in
                cell.labelText.text = fct.title
                cell.labelDescription.text = fct.descriptionField
                if let imageHref = fct.imageHref as? String {
                    cell.imageViewFeed.setImage(with: imageHref)
                }
            })
        }
        
        DispatchQueue.main.async {
            self.homeTableView.dataSource = self.dataSource
            self.homeTableView?.reloadData()
        }
    }
}




