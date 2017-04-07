//
//  MPCManager.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?)
    weak var delegate : CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

class MultipeerCommunicator: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, Communicator {
    
    fileprivate let serviceType = "tinkoff-chat"
    fileprivate let discoveryInfoUserNameKey = "userName"
    
    fileprivate let messageEventTypeKey = "eventType"
    fileprivate let messageEventTypeDescription = "TextMessage"
    fileprivate let messageIdKey = "messageId"
    fileprivate let messageTextKey = "text"
    
    fileprivate func generateMessageId() -> String {
        return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
    }
    
    fileprivate let myPeerId = MCPeerID(displayName: UUID().uuidString)
    
    fileprivate var serviceBrowser: MCNearbyServiceBrowser?
    fileprivate var serviceAdvertiser: MCNearbyServiceAdvertiser?
    
    fileprivate func createMessageWith(text: String) -> [String: String]  {
        
        return  [messageEventTypeKey : messageEventTypeDescription,
                 messageIdKey : generateMessageId(),
                 messageTextKey : text]
    }
    
    fileprivate var sessionsByPeerIDKey = [MCPeerID : MCSession]()
    
    weak var delegate : CommunicatorDelegate?
    var online: Bool = false
    
    // MARK: -
    
    override init() {
        super.init()
        setup()
    }
    
    deinit {
        serviceAdvertiser?.stopAdvertisingPeer()
        serviceBrowser?.stopBrowsingForPeers()
    }
    
    fileprivate func setup() {
        configureServiceAdvertiser()
        configureServiceBrowser()
    }
    
    fileprivate func configureServiceAdvertiser() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: getMyDiscoveryInfo(), serviceType: serviceType)
        serviceAdvertiser?.delegate = self
        serviceAdvertiser?.startAdvertisingPeer()
    }
    
    fileprivate func getMyDiscoveryInfo() -> Dictionary<String, String>? {
        var discoveryInfo:Dictionary<String, String>?
//        if let myName = "Terekhov" {
//            discoveryInfo = [discoveryInfoUserNameKey : myName]
//        }
       
        return  [discoveryInfoUserNameKey : "Terekhov"]
    }
    
    fileprivate func configureServiceBrowser() {
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType:serviceType)
        serviceBrowser?.delegate = self
        serviceBrowser?.startBrowsingForPeers()
    }
    
    // MARK: - Communicator
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
//            let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
//            let mySession = sessionsByPeerIDKey[peerID]
//            try? mySession?.send(data!, toPeers: peers, with: .reliable )
    }

    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Swift.Void) {
        
            let session = getSessionFor(peer: peerID)
            let accept = !session.connectedPeers.contains(peerID)
            invitationHandler(accept, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }

    // MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let session = getSessionFor(peer: peerID)
        if !session.connectedPeers.contains(peerID) {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        if peers.contains(peerID) {
////            let index = peers.index(of: peerID)
////            peers.remove(at: index!)
//        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //print(error.localizedDescription)
    }
    
    // MARK: -
    
    func getSessionFor(peer: MCPeerID) -> MCSession {
        
        var session = sessionsByPeerIDKey[peer]
        if session == nil {
            session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
            session?.delegate = self
            sessionsByPeerIDKey[peer] = session
        }
        
        return session!
    }
    
    // MARK: - MCSessionDelegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected devices: \(session.connectedPeers.map{$0.displayName})")
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
      // delegate?.didRecieveMessage(text: <#T##String#>, fromUser: <#T##String#>, toUser: <#T##String#>)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
}
