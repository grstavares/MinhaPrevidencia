//
//  DocumentsVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DocumentsVC: AppViewController {

    static func instantiate(with coordinator: AppCoordinator, state: AppState) -> UIViewController? {

        let storyboard = UIStoryboard(name: "DocumentsSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: DocumentsVC.self)
        controller?.coordinator = coordinator
        controller?.state = state
        return controller

    }

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    var dataSource: [Document] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        self.addMenuButton()
        self.addAcessoryButtons()

        self.registerCell()
        self.configureDataSource()

    }

    func addAcessoryButtons() {

        let filterButton = UIBarButtonItem(image: UIImage(named: "iconFilter"), style: .plain, target: self, action: #selector(self.filterDataSource(sender:)))
        let taggedButton = UIBarButtonItem(image: UIImage(named: "iconTags"), style: .plain, target: self, action: #selector(self.filterDataSource(sender:)))
        self.navigationItem.rightBarButtonItems = [filterButton, taggedButton]

    }

    @objc func filterDataSource(sender: Any) {}

    @objc func showTagged(sender: Any) {}

    @objc func createNew(sender: Any) {}

    private func registerCell() {

        let nib = UINib(nibName: DocumentCell.cellId, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: DocumentCell.cellId)

    }

    private func configureDataSource() {

        self.tableView.dataSource = self
        self.state?.documents.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { values in
                self.dataSource = values
                self.tableView.reloadData()
            }).disposed(by: self.disposeBag)

    }

}

extension DocumentsVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.dataSource.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.cellId, for: indexPath) as? DocumentCell {

            let object = self.dataSource[indexPath.row]
            cell.configure(with: object)
            return cell

        } else { return UITableViewCell() }

    }

}
