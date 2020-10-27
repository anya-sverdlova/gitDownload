//
//  ResultTableViewCell.swift
//  GitDownload
//
//  Created by Anna Sverdlova on 27.10.2020.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startsLabel: UILabel!
    
    
    var data: Result! {
        didSet {
            setData()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = ""
        descriptionLabel.text = ""
        startsLabel.text = ""
    }

    private func setData() {
        nameLabel.text = data.name
        descriptionLabel.text = data.description
        startsLabel.text = "Stars " + data.stars
    }
}
