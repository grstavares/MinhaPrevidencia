//
//  ComplaintsVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 17/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ComplaintsVC: AppViewController {

    static func instantiate(with coordinator: AppCoordinator, state: AppState) -> UIViewController? {

        let storyboard = UIStoryboard(name: "ComplaintsSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: ComplaintsVC.self)
        controller?.coordinator = coordinator
        controller?.state = state
        return controller

    }

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    var dataSource: [Complaint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMenuButton()
        self.addAcessoryButtons()
    }

    func addAcessoryButtons() {

        let filterButton = UIBarButtonItem(image: UIImage(named: "iconFilter"), style: .plain, target: self, action: #selector(self.filterDataSource(sender:)))
        let taggedButton = UIBarButtonItem(image: UIImage(named: "iconTags"), style: .plain, target: self, action: #selector(self.filterDataSource(sender:)))
        let createButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.createNew(sender:)))
        self.navigationItem.rightBarButtonItems = [filterButton, taggedButton, createButton]

    }

    @objc func filterDataSource(sender: Any) {}

    @objc func showTagged(sender: Any) {}

    @objc func createNew(sender: Any) {}

}
