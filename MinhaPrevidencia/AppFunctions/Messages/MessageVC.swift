//
//  MessageVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageVC: AppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAcessoryButtons()
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    @IBOutlet weak var textSubject: UITextField!
    @IBOutlet weak var textContent: UITextView!

    let disposeBag = DisposeBag()
    var dataSource: CommunicationMessage?

    func addAcessoryButtons() {

        let sendButton = UIBarButtonItem(image: UIImage(named: "iconSend"), style: .plain, target: self, action: #selector(self.sendMessage(sender:)))
        self.navigationItem.rightBarButtonItems = [sendButton]

    }

    @objc func sendMessage(sender: Any) { }

    @IBAction func buttonTagTapped(sender: UIButton) { }

    @IBAction func buttonReplyTapped(sender: UIButton) { }

    @IBAction func buttonFowardTapped(sender: UIButton) { }

}
