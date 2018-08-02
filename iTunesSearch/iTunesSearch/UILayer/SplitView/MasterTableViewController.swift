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

//TODO: The naming is incorrect, this is not a tableViewController.
class MasterTableViewController: UIViewController {
    
    //**********************
    //MARK:- IBOutlets
    //**********************
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noSearchResultsLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
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
        self.configureTableView()
        //Informing the Viewmodel to execute these instructions if the search results change.
        self.masterViewModel.searchResultsUpdatedHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.showOrHideNoResults()
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
        // added this to ensure that the searchController doesn't stay on screen when showing the detail on iPhone.
        self.definesPresentationContext = true

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Type to search music"
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    private func configureTableView(){
        self.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        self.tableView.backgroundColor = UIColor.clear
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //**********************
    //MARK:- UI Behavior
    //**********************
    private func showOrHideNoResults(){
        if self.masterViewModel.models.count == 0{
            noSearchResultsLabel.isHidden = false
        }else{
            noSearchResultsLabel.isHidden = true
        }
    }
    func updateMainViewBasedOnDetail(image: UIImage){
        
    }
}
extension MasterTableViewController:UITableViewDataSource{
    //**********************
    //MARK:- Table view data source
    //**********************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.masterViewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This has to be as! as this controller cannot deal with any other cell for now.
        //We can default to UITableViewCell() to avoid crash, but in this case it should crash.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MasterTableViewCell
        
        let model = self.masterViewModel.models[indexPath.row]
        // Configure the cell...
        cell.updateFrom(source: model)
        return cell
    }

}

extension MasterTableViewController: UITableViewDelegate{
    //**********************
    //MARK:- Table view Delegate
    //**********************

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = masterSelectionDelegate as? DetailViewController, let detailNavController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavController, sender: nil)
        }
        // Just inform the delegate that selection has changed. What it does is not my busisness.
        self.masterSelectionDelegate?.trackSelected(source: self.masterViewModel.models[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Delay the fecth of the images only until the cell is going to be displayed.
        let model = self.masterViewModel.models[indexPath.row]
        let cellsTokenFromViewModel = model.cellIdentificationToken
        model.fetchThumbnailImage(token: cellsTokenFromViewModel) { [weak cell] (token, image) in
            guard let cell = cell as? MasterTableViewCell else{
                return
            }
            guard token == cell.cellIdentificationToken else{
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

extension MasterTableViewController: UpdateMasterUIProtocol{
    func updateMainViewBasedOnDetail(image: UIImage?) {
        self.backgroundImageView.image = image
        self.backgroundImageView.alpha = 0.05
    }
}

