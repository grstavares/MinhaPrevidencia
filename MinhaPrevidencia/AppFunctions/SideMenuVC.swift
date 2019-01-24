//
//  SideMenuVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 15/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum MenuItens: CaseIterable {
    case news
    case retirement
    case messages
    case activities
    case results
    case documents
    case complaints
    case userProfile

    var menuLabel: String {
        switch self {
        case .news: return "Notícias"
        case .retirement: return "Aposentadoria"
        case .messages: return "Mensagens"
        case .activities: return "Atividades"
        case .results: return "Resultados"
        case .documents: return "Documentos"
        case .complaints: return "Ouvidoria"
        case .userProfile: return "Perfil do Usuário"
        }
    }

    var menuIconNamedImage: String {
        switch self {
        case .news: return "iconMenu"
        case .retirement: return "iconMenu"
        case .messages: return "iconMenu"
        case .activities: return "iconMenu"
        case .results: return "iconMenu"
        case .documents: return "iconMenu"
        case .complaints: return "iconMenu"
        case .userProfile: return "iconMenu"
        }
    }

    var appAction: AppCoordinatorAction {
        switch self {
        case .news: return AppNavigation.navigateTo(.newsReport)
        case .retirement: return AppNavigation.navigateTo(.retirement)
        case .messages: return AppNavigation.navigateTo(.messages)
        case .activities: return AppNavigation.navigateTo(.activities)
        case .results: return AppNavigation.navigateTo(.financialResults)
        case .documents: return AppNavigation.navigateTo(.documents)
        case .complaints: return AppNavigation.navigateTo(.complaints)
        case .userProfile: return AppNavigation.navigateTo(.userProfile)
        }
    }

}

class SideMenuVC: UIViewController {

    static func instantiate(with coordinator: AppCoordinator, injector: AppInjector) -> UIViewController? {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(type: SideMenuVC.self)
        controller?.coordinator = coordinator
        controller?.injector = injector
        return controller

    }

    var coordinator: AppCoordinator?
    var injector: AppInjector?

    @IBOutlet weak var userThumnail: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDetail: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib.init(nibName: "SideMenuItemCell", bundle: Bundle.main)
        self.tableView.register(cellNib, forCellReuseIdentifier: SideMenuItemCell.cellId)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

}

extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItens.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuItemCell.cellId) as? SideMenuItemCell else { return UITableViewCell() }
        let menuItem = MenuItens.allCases[indexPath.row]
        cell.menuItemIcon.image = UIImage(named: menuItem.menuIconNamedImage)
        cell.menuItemLabel.text = menuItem.menuLabel
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selected = MenuItens.allCases[indexPath.row]
        self.coordinator?.perform(action: selected.appAction, from: self)
        self.coordinator?.perform(action: AppNavigation.toggleMenu, from: self)

    }

}

class SideMenuItemCell: UITableViewCell {

    @IBOutlet weak var menuItemIcon: UIImageView!
    @IBOutlet weak var menuItemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static let cellId = "SideMenuItemCell"

}
