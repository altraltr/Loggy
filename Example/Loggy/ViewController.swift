//
//  ViewController.swift
//  Loggy
//
//  Created by altraltr on 12/10/2023.
//  Copyright (c) 2023 altraltr. All rights reserved.
//

import UIKit
import Loggy

class ViewController: UIViewController {
    
    let l = Loggy.shared
    
    let showLogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Log", for: .normal)
        button.addTarget(self, action: #selector(showLogButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        printx("I am app!")
        printx("Hello from viewDidLoad!", types: [.lifecycle])
        
        printx("2+2 = 4 ?")
        expectedPrintx((2+2), 4)
        expectedPrintx(true, true, true)
        printx("2+2 != 5", types: [.error])
        expectedPrintx((2+2), 5)
        expectedPrintx(true, false, true)
        
        view.addSubview(showLogButton)
        NSLayoutConstraint.activate([
            showLogButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showLogButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showLogButtonTapped() {
        let vc = LoggyViewController(l.returnFullCurrentLog())
        present(vc, animated: true)
    }
}

