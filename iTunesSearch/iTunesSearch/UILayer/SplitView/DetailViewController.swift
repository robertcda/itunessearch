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
    //MARK:- View life cycle methods
    //**********************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = 100
        // Configure Activity Indicator
        self.imageViewActivityIndicator?.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//**********************
//MARK:- On Change of Album.
//**********************

extension DetailViewController: MasterSelectionDelegate{
    func trackSelected(source: TrackViewModel) {
        self.viewModel = source
        
        self.trackNameLabel.text = source.track.trackName
        self.albumLabel.text = source.track.albumName
        self.artistLabel.text = source.track.artistName
        self.priceLabel.text = "\(source.track.price)"
        self.releaseDateLabel.text = "\(source.track.releaseDate)"
        
        self.imageViewState = .fetching
        source.fetchArtwork { [weak self] (image) in
            self?.imageViewState = .fetched(image)
        }
    }
}
