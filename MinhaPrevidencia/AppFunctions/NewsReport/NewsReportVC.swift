//
//  NewsReportVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsReportVC: AppViewController {

    static func instantiate(with coordinator: AppCoordinator, state: AppState) -> UIViewController? {

        let storyboard = UIStoryboard(name: "NewsReportSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: NewsReportVC.self)
        controller?.coordinator = coordinator
        controller?.state = state
        return controller

    }

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var newsContent: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAcessoryButtons()
    }

    func addAcessoryButtons() { }

    @IBAction func buttonTagTapped(sender: UIButton) { }
    @IBAction func buttonPrintTapped(sender: UIButton) { }
    @IBAction func buttonShareTapped(sender: UIButton) { }

}
