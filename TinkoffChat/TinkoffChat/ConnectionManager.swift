//
//  MPCManager.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ConnectionManagerDelegate {
    
}

class ConnectionManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    private let serviceType = "tinkoff-chat"
    
    var myPeerId = MCPeerID(displayName: UIDevice.current.name)
    var serviceBrowser: MCNearbyServiceBrowser!
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId)
        session.delegate = self
        return session
    }()

    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    var delegate: ConnectionManagerDelegate?
    
     // MARK: - Initialization
    
    override init() {
        super.init()
        setup()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func setup() {
        configureServiceAdvertiserWith(peer: myPeerId)
        configureServiceBrowserWith(peer: myPeerId)
    }
    
    func configureServiceAdvertiserWith(peer: MCPeerID) {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType:serviceType)
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func configureServiceBrowserWith(peer: MCPeerID) {
        serviceBrowser = MCNearbyServiceBrowser(peer: peer, serviceType:serviceType)
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Swift.Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session) //accepts all incoming connections
        self.invitationHandler = invitationHandler
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }

    // MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 20) //invites any peer
        foundPeers.append(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
        if foundPeers.contains(peerID) {
            let index = foundPeers.index(of: peerID)
            foundPeers.remove(at: index!)
        }
    }
    
    // MARK: - MCSessionDelegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            print("Connected devices: \(session.connectedPeers.map{$0.displayName})")
        
        
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let data = String(data: data, encoding: .utf8)!
        print(data)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
         print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
}


