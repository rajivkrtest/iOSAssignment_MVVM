//
//  FactsViewModel.swift
//  iOSAssignment_MVVM
//
//  Created by Rajiv Kumar on 08/10/20.
//

import Foundation

class FactsViewModel : NSObject {
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var bindErrorsViewModelToController: (() -> ())?
    var bindFactsViewModelToController : (() -> ()) = {}
    
    // MARK: - Properties
    private(set) var factsData : FactsResponse? {
        didSet {
            self.bindFactsViewModelToController()
        }
    }
    
    private(set) var error: APIError? {
        didSet {
            self.bindErrorsViewModelToController?()
        }
    }
    
    override init() {
        super.init()
        callFuncToFetchFactsData()
    }
    
    func callFuncToFetchFactsData() {
        APIClient.shared.getFacts(parameters: [:], completion: { (results) in
            if let results = results {
                self.factsData = results
            }
        }) { (error) in
            self.error = error
        }
    }
}
