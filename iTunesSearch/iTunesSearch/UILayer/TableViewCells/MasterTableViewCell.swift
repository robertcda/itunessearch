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
}

class MasterTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var firstRowLabelTitleLabel: UILabel!
    @IBOutlet weak var firstRowValueLabel: UILabel!
    @IBOutlet weak var secondRowValueLabel: UILabel!
    @IBOutlet weak var secondRowTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateFrom(source:MasterTableViewCellDataSource){
        self.firstRowLabelTitleLabel.text = source.firstRowLabelTitleLabel
        self.firstRowValueLabel.text = source.firstRowValueLabel
        
        self.secondRowTitleLabel.text = source.secondRowTitleLabel
        self.secondRowValueLabel.text = source.secondRowValueLabel
    }

}
