//
//  ProgressHUD.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/18/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit

class ProgressHUD: UIVisualEffectView {
    var text: String? {
        didSet {
            label.text = text
        }
    }

    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView

    init(text: String) {
        self.text = text
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        text = ""
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if let superview = self.superview {
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                           y: superview.frame.height / 2 - height / 2,
                           width: width,
                           height: height)
            vibrancyView.frame = bounds

            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)

            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }

    func show() {
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
