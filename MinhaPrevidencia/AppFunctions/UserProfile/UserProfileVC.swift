//
//  UserProfileVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserProfileVC: AppViewController {

    static func instantiate(with coordinator: AppCoordinator, state: AppState) -> UIViewController? {

        let storyboard = UIStoryboard(name: "UserProfileSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: UserProfileVC.self)
        controller?.coordinator = coordinator
        controller?.state = state
        return controller

    }

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    var dataSource: UserProfile?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMenuButton()
        self.addAcessoryButtons()
    }

    func addAcessoryButtons() { }

}
