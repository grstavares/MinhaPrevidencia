//
//  MessagesVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessagesVC: AppViewController {

    static func instantiate(with coordinator: AppCoordinator, state: AppState) -> UIViewController? {

        let storyboard = UIStoryboard(name: "MessagesSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: MessagesVC.self)
        controller?.coordinator = coordinator
        controller?.state = state
        return controller

    }

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    var dataSource: [CommunicationMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMenuButton()
        self.addAcessoryButtons()
    }

    func addAcessoryButtons() {

        let filterButton = UIBarButtonItem(image: UIImage(named: "iconFilter"), style: .plain, target: self, action: #selector(self.filterDataSource(sender:)))
        let taggedButton = UIBarButtonItem(image: UIImage(named: "iconTags"), style: .plain, target: self, action: #selector(self.filterDataSource(sender:)))
        let createButton = UIBarButtonItem(image: UIImage(named: "iconCreate"), style: .plain, target: self, action: #selector(self.filterDataSource(sender:)))
        self.navigationItem.rightBarButtonItems = [filterButton, taggedButton, createButton]

    }

    @objc func filterDataSource(sender: Any) {}
    @objc func showTagged(sender: Any) {}
    @objc func createNew(sender: Any) {}

}
