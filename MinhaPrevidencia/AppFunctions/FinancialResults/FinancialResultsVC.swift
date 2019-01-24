//
//  FinancialResultsVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FinancialResultsVC: AppViewController {

    static func instantiate(with coordinator: AppCoordinator, state: AppState) -> UIViewController? {

        let storyboard = UIStoryboard(name: "FinancialResultsSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: FinancialResultsVC.self)
        controller?.coordinator = coordinator
        controller?.state = state
        return controller

    }

    @IBOutlet weak var viewGraph: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonPeriod: UIButton!

    let disposeBag = DisposeBag()
    var dataSource: [FinancialEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMenuButton()
        self.addAcessoryButtons()
    }

    func addAcessoryButtons() { }

    @IBAction func buttonPreviousTapped(sender: UIButton) { }

    @IBAction func buttonNextTapped(sender: UIButton) { }

    @IBAction func buttonPeriodTapped(sender: UIButton) { }

}
