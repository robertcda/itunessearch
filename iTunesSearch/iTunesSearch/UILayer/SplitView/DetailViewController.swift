//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import UIKit
protocol UpdateMasterUIProtocol: class{
    func updateMainViewBasedOnDetail(image:UIImage?)
}
class DetailViewController: UIViewController {

    enum DetailViewImageState{
        case fetching, error, fetched(UIImage)
    }
    
    //**********************
    //MARK:- IBOutlet
    //**********************
    @IBOutlet weak var imageViewActivityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var backgroundImageView: UIImageView!
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
    var identificationToken: String = ""
    
    weak var masterViewDelegate:UpdateMasterUIProtocol? = nil
    
    //**********************
    //MARK:- ImageView states.
    //**********************
    var imageViewState:DetailViewImageState = .fetching{
        didSet{
            let imageViews = [imageView,backgroundImageView]
            DispatchQueue.main.async {
                switch self.imageViewState {
                case .fetching:
                    imageViews.forEach({ $0?.image = #imageLiteral(resourceName: "placeholder") })
                    
                    self.imageView?.alpha = 0.3
                    self.backgroundImageView?.alpha = 0.05
                    
                    self.masterViewDelegate?.updateMainViewBasedOnDetail(image: nil)
                    self.imageViewActivityIndicator?.startAnimating()
                case .error:
                    
                    self.imageView?.image = #imageLiteral(resourceName: "no-image")
                    self.backgroundImageView?.image = nil
                    
                    self.imageViewActivityIndicator?.stopAnimating()
                    self.masterViewDelegate?.updateMainViewBasedOnDetail(image: nil)
                case .fetched(let image):
                    imageViews.forEach({ $0?.image = image })

                    self.imageView?.alpha = 1
                    self.backgroundImageView?.alpha = 0.05
                    
                    self.imageViewActivityIndicator?.stopAnimating()
                    self.masterViewDelegate?.updateMainViewBasedOnDetail(image: image)
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
        
        self.configureMainView()
        self.configureImageView()
        
        // Configure Activity Indicator
        self.imageViewActivityIndicator?.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //**********************
    //MARK:- View Configuration
    //**********************
    private func configureImageView(){
        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = 100
    }
    private func configureMainView(){
        self.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        self.updateDetailViewState(state: .noSelection)
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
        
        self.updateImageFromViewModel()
    }
    
    private func updateImageFromViewModel(){
        guard let viewModel = self.viewModel else {
            return
        }

        self.imageViewState = .fetching
        
        self.identificationToken = viewModel.detailViewIdentificationToken
        viewModel.fetchArtwork(token: self.identificationToken) { [weak self] (token, image) in
            guard let myToken = self?.identificationToken else{
                return
            }
            guard myToken == token else{
                return
            }
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
