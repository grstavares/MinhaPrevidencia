//
//  NewsReportCell.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 15/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

class NewsReportCell: UITableViewCell {

    static let cellId = "NewsReportCell"

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsSummary: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with newsReport: NewsReport) {

        let uiImage = UIImage(named: "imageNewsReport")
        self.newsImage.image = uiImage
        self.newsTitle.text = newsReport.title
        self.newsSummary.text = newsReport.contents

    }

}
