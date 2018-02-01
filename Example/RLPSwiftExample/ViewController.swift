//
//  ViewController.swift
//  RLPSwiftExample
//
//  Created by Aleph Retamal on 1/2/18.
//  Copyright © 2018 Lalacode. All rights reserved.
//

import UIKit
import RLPSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        do {
            let encoded = try RLP.encode("hello world")
            print("Success: \(encoded)")
        } catch {
            print("Error: \(error)")
        }
    }
    
}
