//
//  FlickrSearchCell.swift
//  MobiquityTest
//
//  Created by Christopher Nassar on 08/07/2021.
//

import UIKit

protocol FlickrSearchCellDataSource {
    func configureView(imageURL: String?, title: String?)
}

class FlickrSearchCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var flickrImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flickrImageView.image = nil
        titleLabel.text = nil
    }
}

extension FlickrSearchCell: FlickrSearchCellDataSource{
    func configureView(imageURL: String?, title: String?) {
        if let imageURL = imageURL {
            UIHelper.setImageAsync(urlStr: imageURL, imageView: flickrImageView)
        }
        titleLabel.text = title
    }
}
