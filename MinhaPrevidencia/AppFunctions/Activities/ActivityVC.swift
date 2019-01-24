//
//  ActivityVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ActivityVC: AppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAcessoryButtons()
    }

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    var dataSource: CommunicationMessage?

    func addAcessoryButtons() {

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.buttonSaveTaped(sender:)))
        self.navigationItem.rightBarButtonItems = [saveButton]

    }

    @objc func buttonSaveTaped(sender: UIBarButtonItem) { }

    @IBAction func buttonTagTapped(sender: UIButton) { }

    @IBAction func buttonAlarmTapped(sender: UIButton) { }

    @IBAction func buttonFowardTapped(sender: UIButton) { }

}

class StaticDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }

}
