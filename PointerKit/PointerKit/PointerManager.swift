//
//  PointerManager.swift
//  PointerKit
//
//  Created by Louis D'hauwe on 19/05/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

import PTFakeTouch
import UIKit
import MultipeerConnectivity
	
public class PointerManager: NSObject, MCBrowserViewControllerDelegate, PointerConnectionDelegate {
	
	fileprivate var browser: MCBrowserViewController?
	
	let connection = PointerConnection()
	
	var pointerView: UIView!
	
	let connectionViewController: UIViewController
	let window: UIWindow
	
	public init(with connectionViewController: UIViewController, in window: UIWindow) {
		
		self.connectionViewController = connectionViewController
		self.window = window
		
		super.init()
		
		connection.delegate = self

		let image = UIImage(named: "mouse-pointer", in: Bundle(for: PointerManager.self), compatibleWith: nil)

		pointerView = UIImageView(image: image)
		pointerView.frame = CGRect(x: 400, y: 400, width: 16, height: 26)
		pointerView.backgroundColor = .clear
		
		pointerView.layer.shadowOffset = CGSize(width: 0, height: 2)
		pointerView.layer.shadowColor = UIColor.black.cgColor
		pointerView.layer.shadowRadius = 2.0
		pointerView.layer.shadowOpacity = 0.3
		
		
		// create the browser viewcontroller with a unique service name
		self.browser = MCBrowserViewController(serviceType: connection.serviceType, session: connection.session)
		
		self.browser?.delegate = self
		self.browser?.maximumNumberOfPeers = 2
		
	}
	
	public func showConnector() {
		
		pointerView.isUserInteractionEnabled = false
		UIApplication.shared.keyWindow?.addSubview(pointerView)
		
		//		let pointId = PTFakeMetaTouch.fakeTouchId(PTFakeMetaTouch.getAvailablePointId(), at: CGPoint(x: 160, y: 170), with: .began)
		
		//		PTFakeMetaTouch.fakeTouchId(pointId, at: CGPoint(x: 160, y: 170), with: .ended)
		
		connectionViewController.present(browser!, animated: true, completion: nil)
		
	}
	
	
	public func didReceive(mouseDelta: MouseDelta) {
		
		var newPoint = pointerView.center
		
		newPoint.x += CGFloat(mouseDelta.deltaX)
		newPoint.y += CGFloat(mouseDelta.deltaY)
		
		var newPointerFrame = pointerView.frame
		newPointerFrame.origin.x += CGFloat(mouseDelta.deltaX)
		newPointerFrame.origin.y += CGFloat(mouseDelta.deltaY)
		
		guard let window = UIApplication.shared.keyWindow else {
			return
		}
		
		guard window.bounds.intersects(newPointerFrame) else {
			return
		}
		
		if let currentTouchId = currentTouchId {
			PTFakeMetaTouch.fakeTouchId(currentTouchId, at: newPoint, with: .moved)
		}
		
//		UIView.animate(withDuration: 0.10) {
		
			self.pointerView.center = newPoint

//		}
		
	}
	
	var currentTouchId: Int?
	
	public func didReceive(mouseEvent: MouseEvent) {
		
		let cursorPos = pointerView.frame.origin
		
		switch mouseEvent {
		case .down:
			let pointId = PTFakeMetaTouch.fakeTouchId(PTFakeMetaTouch.getAvailablePointId(), at: cursorPos, with: .began)
			
			currentTouchId = pointId
			//			PTFakeMetaTouch.fakeTouchId(pointId, at: cursorPos, with: .ended)
			
		case .up:
			
			guard let currentTouchId = currentTouchId else {
				return
			}
			
			PTFakeMetaTouch.fakeTouchId(currentTouchId, at: cursorPos, with: .ended)
			
		case .dragged:
			
			guard let currentTouchId = currentTouchId else {
				return
			}
			
			//			PTFakeMetaTouch.fakeTouchId(currentTouchId, at: cursorPos, with: .moved)
			
			
		}
		
		
		
	}
	
	public func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController)  {
		// Called when the browser view controller is dismissed (ie the Done
		// button was tapped)
		
		browserViewController.dismiss(animated: true, completion: nil)
		
	}
	
	public func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController)  {
		// Called when the browser view controller is cancelled
		
		//		self.game = nil
		browserViewController.dismiss(animated: true, completion: nil)
	}
	
}

