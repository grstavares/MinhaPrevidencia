//
//  RetirementVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RetirementVC: AppViewController {

    static func instantiate(with coordinator: AppCoordinator, state: AppState) -> UIViewController? {

        let storyboard = UIStoryboard(name: "RetirementSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: RetirementVC.self)
        controller?.coordinator = coordinator
        controller?.state = state
        return controller

    }

    @IBOutlet weak var contentSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slideBar: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var thumbnailBottom: NSLayoutConstraint!

    let disposeBag = DisposeBag()
    var dataSource: Retirement?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMenuButton()
        self.addAcessoryButtons()
    }

    func addAcessoryButtons() { }

    @IBAction func contentSelectorTapped(sender: UISegmentedControl) { }

}
