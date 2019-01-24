//
//  FinancialResultsCategoryVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FinancialResultsCategoryVC: AppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAcessoryButtons()
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonPeriod: UIButton!

    let disposeBag = DisposeBag()
    var dataSource: [FinancialEntry] = []

    func addAcessoryButtons() { }

    @IBAction func buttonPreviousTapped(sender: UIButton) { }

    @IBAction func buttonNextTapped(sender: UIButton) { }

    @IBAction func buttonPeriodTapped(sender: UIButton) { }

}
