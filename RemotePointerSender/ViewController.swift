//
//  ViewController.swift
//  RemotePointerSender
//
//  Created by Louis D'hauwe on 04/05/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Cocoa
import MultipeerConnectivity
import PointerKit_macOS

class ViewController: NSViewController, MCBrowserViewControllerDelegate {

	fileprivate var browser: MCBrowserViewController?

	let connection = PointerConnection()

	var trackingArea: NSTrackingArea!
	override func viewDidLoad() {
		super.viewDidLoad()

	
		
		// create the browser viewcontroller with a unique service name
		self.browser = MCBrowserViewController(serviceType: connection.serviceType, session: connection.session)
		
		self.browser?.delegate = self
		self.browser?.maximumNumberOfPeers = 2
		
		
		
	}
	
	override func viewDidLayout() {
		super.viewDidLayout()
		
		if let prevTrackingArea = trackingArea {
			self.view.removeTrackingArea(prevTrackingArea)
		}
		
		let options : NSTrackingAreaOptions = [.mouseMoved, .activeAlways, .enabledDuringMouseDrag]
		
		trackingArea = NSTrackingArea(rect: self.view.bounds, options: options, owner: self.view, userInfo: nil)
		self.view.addTrackingArea(trackingArea)
		
	}
	
	override func viewDidAppear() {
		super.viewDidAppear()
	
		self.presentViewControllerAsSheet(self.browser!)

	}
	
	
	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController)  {
		// Called when the browser view controller is dismissed (ie the Done
		// button was tapped)
		
		dismissViewController(browserViewController)
	}
	
	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController)  {
		// Called when the browser view controller is cancelled
		
//		self.game = nil
		dismissViewController(browserViewController)
	}
	
	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	override func mouseMoved(with event: NSEvent) {
		print("Mouse moved: \(event.deltaX) \(event.deltaY)")
		
		let mouseDelta = MouseDelta(x: Int(event.deltaX), y: Int(event.deltaY))
		connection.sendMouseDelta(mouseDelta)
		
	}

	override func mouseDown(with event: NSEvent) {
		
		connection.sendMouseEvent(.down)
		print("mouse down")
	}
	
	override func mouseUp(with event: NSEvent) {
		
		connection.sendMouseEvent(.up)
		print("mouse up")
	}
	
	override func mouseDragged(with event: NSEvent) {
		
		print("Mouse moved: \(event.deltaX) \(event.deltaY)")
		
		let mouseDelta = MouseDelta(x: Int(event.deltaX), y: Int(event.deltaY))
		connection.sendMouseDelta(mouseDelta)
		
		connection.sendMouseEvent(.dragged)
		print("mouse dragged")

	}
	
}

class CustomView : NSView {
	
//	var trackingArea : NSTrackingArea?
//	
//	override func updateTrackingAreas() {
//		if trackingArea != nil {
//			self.removeTrackingArea(trackingArea!)
//		}
//		let options : NSTrackingAreaOptions =
//			[.activeWhenFirstResponder, .mouseMoved ]
//		trackingArea = NSTrackingArea(rect: self.bounds, options: options,
//		                              owner: self, userInfo: nil)
//		self.addTrackingArea(trackingArea!)
//	}
//	
	
}
