//
//  MasterTableViewController.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import UIKit

/**********
 Whoever wants to know the selection of the masterView implement this.
 **********/
protocol MasterSelectionDelegate {
    func trackSelected(source:TrackViewModel)
}

class MasterTableViewController: UITableViewController {
    
    //**********************
    //MARK:- View Model
    //**********************
    var masterViewModel = MasterViewModel()
    
    //**********************
    //MARK:- search function variables
    //**********************
    let searchController = UISearchController(searchResultsController: nil)
    var searchTextRequest: String = ""
    
    //**********************
    //MARK:- delegate to enable DetailView.
    //**********************
    var masterSelectionDelegate:MasterSelectionDelegate? = nil
    
    //**********************
    //MARK:- View Life cycle
    //**********************

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "iTunes Music Search"
        self.configureSearch()
        
        self.tableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)

        //Informing the Viewmodel to execute these instructions if the search results change.
        self.masterViewModel.searchResultsUpdatedHandler = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**********
     This method sets up the search controller for the tableView.
     **********/
    private func configureSearch(){
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Type to search music"
        self.tableView.tableHeaderView = searchController.searchBar
    }

    //**********************
    //MARK:- Table view data source
    //**********************

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.masterViewModel.models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This has to be as! as this controller cannot deal with any other cell for now.
        //We can default to UITableViewCell() to avoid crash, but in this case it should crash.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MasterTableViewCell
        
        let model = self.masterViewModel.models[indexPath.row]
        // Configure the cell...
        cell.updateFrom(source: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Just inform the delegate that selection has changed. What it does is not my busisness.
        self.masterSelectionDelegate?.trackSelected(source: self.masterViewModel.models[indexPath.row])
        
        if let detailViewController = masterSelectionDelegate as? DetailViewController, let detailNavController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Delay the fecth of the images only until the cell is going to be displayed.
        let model = self.masterViewModel.models[indexPath.row]
        model.showThumbnailImage { [weak cell] (image) in
            guard let cell = cell as? MasterTableViewCell else{
                return
            }
            if let image = image{
                cell.imageViewState = .fetched(image)
            }else{
                cell.imageViewState = .error
            }
        }
    }
}

//**********************
//MARK:- UISearchResultsUpdating
//**********************
extension MasterTableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            // My Job here is to only inform the ViewModel that search text has changed, let it decide if it needs to update me.
            // Refer: property of view model searchResultsUpdatedHandler - it would use that property to update me.
            self.masterViewModel.searchFor(searchText: searchText)
        }
    }
}


