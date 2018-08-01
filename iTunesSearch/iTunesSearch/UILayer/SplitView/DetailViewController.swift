//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    enum DetailViewImageState{
        case fetching, error, fetched(UIImage)
    }
    
    //**********************
    //MARK:- IBOutlet
    //**********************
    @IBOutlet weak var imageViewActivityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var nothingSelectedLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    //**********************
    //MARK:- View Model
    //**********************
    var viewModel: TrackViewModel? = nil
    
    //**********************
    //MARK:- ImageView states.
    //**********************
    var imageViewState:DetailViewImageState = .fetching{
        didSet{
            DispatchQueue.main.async {
                switch self.imageViewState {
                case .fetching:
                    self.imageView?.image = #imageLiteral(resourceName: "placeholder")
                    self.imageViewActivityIndicator?.startAnimating()
                    self.imageView?.alpha = 0.3
                case .error:
                    self.imageView?.image = #imageLiteral(resourceName: "placeholder")
                    self.imageViewActivityIndicator?.stopAnimating()
                case .fetched(let image):
                    self.imageView?.image = image
                    self.imageViewActivityIndicator?.stopAnimating()
                    self.imageView?.alpha = 1
                }
            }
        }
    }
    
    //**********************
    //MARK:- Controller Selection States
    //**********************
    enum DetailViewState{
        case selected, noSelection
    }
    var detailViewState: DetailViewState = .noSelection
    
    func updateDetailViewState(state:DetailViewState){
        switch state {
        case .noSelection:
            mainStackView.isHidden = true
            nothingSelectedLabel.isHidden = false
        case .selected:
            mainStackView.isHidden = false
            nothingSelectedLabel.isHidden = true
        }
    }

    //**********************
    //MARK:- View life cycle methods
    //**********************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateDetailViewState(state: .noSelection)
        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = 100
        // Configure Activity Indicator
        self.imageViewActivityIndicator?.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //**********************
    //MARK:- UpdateFrom ViewModel
    //**********************
    private func updateFromViewModel(){
        guard let viewModel = self.viewModel else {
            return
        }
        // update thhe UI with the details from the View Model.
        self.title = viewModel.detailTitleToDisplay
        self.trackNameLabel.text = viewModel.track.trackName
        self.albumLabel.text = viewModel.track.albumName
        self.artistLabel.text = viewModel.track.artistName
        self.priceLabel.text = viewModel.priceToDisplay
        self.releaseDateLabel.text = viewModel.releaseDateToDisplay
        
        self.imageViewState = .fetching
        viewModel.fetchArtwork { [weak self] (image) in
            if let image = image{
                self?.imageViewState = .fetched(image)
            }else{
                self?.imageViewState = .error
            }
        }
    }
}

//**********************
//MARK:- On Change of Album.
//**********************

extension DetailViewController: MasterSelectionDelegate{
    func trackSelected(source: TrackViewModel) {
        //Update UI to be selected.
        self.updateDetailViewState(state: .selected)

        //Update the ViewModel
        self.viewModel = source
        
        // Update the UI from the ViewModel
        self.updateFromViewModel()
    }
}
