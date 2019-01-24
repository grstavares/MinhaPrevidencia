//
//  ComplaintVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 17/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ComplaintVC: AppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAcessoryButtons()
    }

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    var dataSource: Complaint?

    func addAcessoryButtons() {

        let shareButton = UIBarButtonItem(image: UIImage(named: "iconShare"), style: .plain, target: self, action: #selector(self.shareDocument(sender:)))
        self.navigationItem.rightBarButtonItems = [shareButton]

    }

    @objc func shareDocument(sender: Any) {}

}
