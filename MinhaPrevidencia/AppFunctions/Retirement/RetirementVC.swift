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
    @IBOutlet weak var firstTab: UIView!
    @IBOutlet weak var firstTable: UITableView!
    @IBOutlet weak var secondTab: UIView!
    @IBOutlet weak var secondTable: UITableView!

    private var firstTableDataSource: FirstTableDataSource?
    private var secondTableDataSource: SecondTableDataSource?

    @IBOutlet weak var slideRetirement: RetirementSliderView!

    let disposeBag = DisposeBag()
    var dataSource: Retirement?

    override func viewDidLoad() {

        super.viewDidLoad()
        self.addMenuButton()
        self.addAcessoryButtons()

        self.firstTableDataSource = FirstTableDataSource(rules: ["Lei de Aposentadoria", "Decreto 1234", "Portaria 13234"])
        self.firstTable.dataSource = self.firstTableDataSource

        self.secondTableDataSource = SecondTableDataSource(["Empresa 12345", "Prefeitura Municiapl 453", "Camara Legislativa de Gurupi"])
        self.secondTable.dataSource = self.secondTableDataSource

        self.secondTab.isHidden = true
        self.slideRetirement.progress = 0.7

    }

    func addAcessoryButtons() { }

    @IBAction func contentSelectorTapped(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.secondTab.isHidden = true
            self.firstTab.isHidden = false
        case 1:
            self.firstTab.isHidden = true
            self.secondTab.isHidden = false
        default:
            self.secondTab.isHidden = true
            self.firstTab.isHidden = false

        }

    }

}

class FirstTableDataSource: NSObject, UITableViewDataSource {

    let cellReuseId = "RuleCell"
    let rules: [String]

    init(rules: [String]) {self.rules = rules }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId) else {return UITableViewCell()}
        cell.textLabel?.text = rules[indexPath.row]
        return cell
    }

}

class SecondTableDataSource: NSObject, UITableViewDataSource {

    let cellReuseId = "ContributionCell"
    let contributions: [String]

    init(_ contributions: [String]) {self.contributions = contributions }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contributions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId) else {return UITableViewCell()}
        cell.textLabel?.text = contributions[indexPath.row]
        return cell
    }

}
