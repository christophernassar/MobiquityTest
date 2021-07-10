//
//  HistoryCell.swift
//  MobiquityTest
//
//  Created by Christopher Nassar on 08/07/2021.
//

import UIKit

protocol HistoryCellDataSource {
    func configureView(keyword: String)
}

protocol HistoryCellDelegate: AnyObject {
    func removeKeyword(_ keyword: String)
}

class HistoryCell: UITableViewCell {

    @IBOutlet weak private var keywordLabel: UILabel!
    weak var delegate: HistoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeAction(_ sender: Any) {
        guard let keyword = keywordLabel.text else { return }
        delegate?.removeKeyword(keyword)
    }
}

extension HistoryCell: HistoryCellDataSource {
    func configureView(keyword: String) {
        keywordLabel.text = keyword
    }
}
