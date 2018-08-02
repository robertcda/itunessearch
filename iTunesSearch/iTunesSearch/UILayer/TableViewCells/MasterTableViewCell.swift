//
//  MasterTableViewCell.swift
//  iTunesSearch
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import UIKit

protocol MasterTableViewCellDataSource{
    var firstRowLabelTitleLabel: String { get }
    var firstRowValueLabel: String { get }
    var secondRowValueLabel: String { get }
    var secondRowTitleLabel: String { get }
    var imageViewState: MasterTableViewCell.ImageState { get }
    var cellIdentificationToken:String { get }
}

class MasterTableViewCell: UITableViewCell {
    enum ImageState{
        case fetching, error, fetched(UIImage)
    }

    //**********************
    //MARK:- IBOutlets
    //**********************
    
    @IBOutlet weak var imageLoadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var firstRowLabelTitleLabel: UILabel!
    @IBOutlet weak var firstRowValueLabel: UILabel!
    @IBOutlet weak var secondRowValueLabel: UILabel!
    @IBOutlet weak var secondRowTitleLabel: UILabel!
    
    //**********************
    //MARK:- Image Loding logic
    //**********************
    var cellIdentificationToken: String = ""
    var imageViewState:ImageState = .fetching{
        didSet{
            DispatchQueue.main.async {
                switch self.imageViewState {
                case .fetching:
                    self.leftImageView.image = #imageLiteral(resourceName: "placeholder")
                    self.imageLoadingActivity.startAnimating()
                    self.leftImageView?.alpha = 0.2
                case .error:
                    self.leftImageView.image = #imageLiteral(resourceName: "no-image")
                    self.imageLoadingActivity.stopAnimating()
                    self.leftImageView?.alpha = 0.2

                case .fetched(let image):
                    self.leftImageView?.image = image
                    self.imageLoadingActivity.stopAnimating()
                    self.leftImageView?.alpha = 1
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Make the image view to contain a palceholder.
        // Configure activity indicator
        self.configureActivity()
        self.backgroundColor = UIColor.clear
    }

    //**********************
    //MARK:- Activity Indicator
    //**********************
    private func configureActivity(){
        imageLoadingActivity.hidesWhenStopped = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //**********************
    //MARK:- Updating from Cells DataSource
    //**********************
    func updateFrom(source:MasterTableViewCellDataSource){
        self.firstRowLabelTitleLabel.text = source.firstRowLabelTitleLabel
        self.firstRowValueLabel.text = source.firstRowValueLabel
        self.secondRowTitleLabel.text = source.secondRowTitleLabel
        self.secondRowValueLabel.text = source.secondRowValueLabel
        self.imageViewState = source.imageViewState
        self.cellIdentificationToken = source.cellIdentificationToken
    }
    
    //**********************
    //MARK:- Resuse
    //**********************
    override func prepareForReuse() {
        self.imageViewState = .fetching
        self.firstRowLabelTitleLabel.text = ""
        self.firstRowValueLabel.text = ""
        self.secondRowTitleLabel.text = ""
        self.secondRowValueLabel.text = ""
        self.cellIdentificationToken = ""
        super.prepareForReuse()
    }
}
