//
//  DocumentVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PDFKit
import WebKit

class DocumentVC: AppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAcessoryButtons()
    }

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textView: UITextView!

    let disposeBag = DisposeBag()
    var dataSource: Document?

    func addAcessoryButtons() {

        let shareButton = UIBarButtonItem(image: UIImage(named: "iconShare"), style: .plain, target: self, action: #selector(self.shareDocument(sender:)))
        self.navigationItem.rightBarButtonItems = [shareButton]

    }

    @objc func shareDocument(sender: Any) {}

}
