//
//  PointerConnection.swift
//  RemotePointerSender
//
//  Created by Louis D'hauwe on 04/05/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public struct MouseDelta {
	
	public let deltaX: Int
	public let deltaY: Int
	
	public init(x: Int, y: Int) {
		self.deltaX = x
		self.deltaY = y
	}
	
	init?(dict: [String : Int]) {
		
		guard let x = dict["x"] else {
			return nil
		}
		
		guard let y = dict["y"] else {
			return nil
		}
		
		self.deltaX = x
		self.deltaY = y
		
	}
	
	var dictValue: [String : Int] {
		return ["x" : deltaX, "y" : deltaY]
	}
	
}

public struct MouseEventPackage {
	
	let event: MouseEvent
	
	public init(event: MouseEvent) {
		self.event = event
	}
	
	init?(dict: [String : Int]) {
		
		guard let rawValue = dict["event"] else {
			return nil
		}
		
		guard let event = MouseEvent(rawValue: rawValue) else {
			return nil
		}
		
		self.event = event
	}
	
	var dictValue: [String : Int] {
		return ["event" : event.rawValue]
	}
	
}

public protocol PointerConnectionDelegate: class {
	
	func didReceive(mouseDelta: MouseDelta)
	func didReceive(mouseEvent: MouseEvent)
	
}

public enum MouseEvent: Int {
	case down = 0
	case up = 1
	case dragged = 2
}

public class PointerConnection: NSObject, MCSessionDelegate {
	
	public let serviceType = "pointer"
	
	public let session: MCSession
	public let peerID: MCPeerID
	
	public let assistant: MCAdvertiserAssistant
	
	public weak var delegate: PointerConnectionDelegate?
	
	override public init() {
		
		#if os(macOS)
			self.peerID = MCPeerID(displayName: "Mac")
		#else
			self.peerID = MCPeerID(displayName: UIDevice.current.name)
		#endif
		
		self.session = MCSession(peer: peerID)

		
		self.assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session)
		
		super.init()

		self.session.delegate = self
		self.assistant.start()
		
	}

	public func sendMouseEvent(_ event: MouseEvent) {

		sendDictMsg(MouseEventPackage(event: event).dictValue)

		
	}
	
	public func sendMouseDelta(_ delta: MouseDelta) {
		
		sendDictMsg(delta.dictValue)
		
	}
	
	func sendDictMsg(_ msg: [String : Any]) {
		
		print("Message send: \(msg)")
		
		let data = NSKeyedArchiver.archivedData(withRootObject: msg)
		
		do {
			
			try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
			
		} catch {
			
			print("Error sending data")
			
		}
		
	}
	
	func sendMsg(_ msg: String) {
		
		print("Message send: \(msg)")
		
		let data = msg.data(using: .utf8, allowLossyConversion: false)
		
		do {
			
			try self.session.send(data!, toPeers: self.session.connectedPeers, with: .reliable)
			
		} catch {
			
			print("Error sending data")
			
		}
		
	}
	
	
	// MARK: -
	
	public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)  {
		
		DispatchQueue.main.async {
			
			guard let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Int] else {
				return
			}
			
			if let mouseDelta = MouseDelta(dict: dict) {
				self.delegate?.didReceive(mouseDelta: mouseDelta)
			}

			if let mouseEventPackage = MouseEventPackage(dict: dict) {
				self.delegate?.didReceive(mouseEvent: mouseEventPackage.event)
			}

		}
	}
	
	public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)  {
		
		// Called when a peer starts sending a file to us
	}
	
	public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)  {
		// Called when a file has finished transferring from another peer
	}
	
	public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)  {
		// Called when a peer establishes a stream with us
	}
	
	public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)  {
		// Called when a connected peer changes state (for example, goes offline)
		
		DispatchQueue.main.async {
			
			if state == .connected {
				
				self.sessionDidConnect()
			}
			
			if state == .notConnected {
				
				
				
			}
			
		}
		
	}
	
	func sessionDidConnect() {
		
		self.assistant.stop()
		
	}
	
	func stopGame() {
		
		self.session.disconnect()
		
	}

}
