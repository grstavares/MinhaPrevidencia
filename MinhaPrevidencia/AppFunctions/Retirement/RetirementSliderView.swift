//
//  RetirementSliderView.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 28/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

class RetirementSliderView: UIView {

    var backColor: UIColor = UIColor.lightGray
    var frontColor: UIColor = UIColor.darkGray
    var progress: CGFloat = 0.0
    var icon: UIImage? = UIImage(named: "iconMale")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.backgroundColor = self.backColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = frame.width / 2
        self.backgroundColor = self.backColor
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setFillColor(self.frontColor.cgColor)
        let progressSize = rect.height * progress
        let progressPosition = rect.height - progressSize
        let rectangle = CGRect(x: 0, y: progressPosition, width: rect.width, height: progressSize)
        ctx.fill(rectangle)

        if let image = self.icon {

            let rectWidt = rect.width
            let imageRect = CGRect(x: rect.minX - (rectWidt / 2), y: progressPosition, width: rectWidt * 2, height: rectWidt * 2)
            image.draw(in: imageRect)

        }

    }

}
