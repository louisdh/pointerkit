//
//  ViewController.swift
//  RemotePointer
//
//  Created by Louis D'hauwe on 04/05/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import PointerKit

class ViewController: UIViewController {
	
	var manager: PointerManager!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeRed))
		self.view.addGestureRecognizer(tapGestureRecognizer)

		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	
		manager = PointerManager(with: self, in: UIApplication.shared.keyWindow!)

		manager.showConnector()
	}

	@objc func makeRed() {
		
		print("makeRed")

		self.view.backgroundColor = .red
		
	}
	
	@IBOutlet weak var testBtn: UIButton!

	@IBAction func testBtnAction(_ sender: UIButton) {
		
		print("Test")
		self.view.backgroundColor = .green

	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		print(touches)
		
	}
	
}

