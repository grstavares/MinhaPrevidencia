//
//  DocumentCell.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 08/02/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import SwiftSugarKit

class DocumentCell: UITableViewCell {

    static let cellId = "DocumentCell"

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with document: Document) {

        self.labelTitle.text = document.title
        self.labelDate.text = (document.lastUpdate ?? document.dateCreation).onlyDate

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
