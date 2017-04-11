//
//  MPCManager.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol CommunicatorDelegate : class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didRecieveMessage(text: String, fromUser: String, toUser:String)
}

class MultipeerCommunicator:NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, Communicator {
    
    fileprivate let serviceType = "tinkoff-chat"
    fileprivate let discoveryInfoUserNameKey = "userName"
    
    fileprivate let myPeerId = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    
    fileprivate var serviceBrowser: MCNearbyServiceBrowser
    fileprivate var serviceAdvertiser: MCNearbyServiceAdvertiser

    fileprivate var sessionsByPeerIDKey = [MCPeerID : MCSession]()
    
    fileprivate let peerMessageSerializer = PeerMessageSerializer()
    
    weak var delegate : CommunicatorDelegate?
    var online: Bool = false
    
    // MARK: -
    
    override init() {
        let myDiscoveryInfo = [discoveryInfoUserNameKey : UIDevice.current.name]
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType:serviceType)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: myDiscoveryInfo, serviceType: serviceType)
        super.init()
        setup()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    fileprivate func setup() {
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    func updateMyPeerName(_ name: String) {
//        serviceAdvertiser.stopAdvertisingPeer()
//        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: [discoveryInfoUserNameKey : name], serviceType: serviceType)
//        serviceAdvertiser.delegate = self
//        serviceAdvertiser.startAdvertisingPeer()
        
        print("\(name)")
    }
    
    // MARK: - Communicator
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        if let peerID = getPeerIDFor(userId: userID) {
            let session = sessionsByPeerIDKey[peerID]
            do {
                let serializedMessage = try peerMessageSerializer.serializeMessageWith(text: string)
                try session!.send(serializedMessage, toPeers: [peerID], with: .reliable )
                completionHandler?(true, nil)
            }
            catch {
                completionHandler?(false, error)
            }
        }
    }
    
    fileprivate func getPeerIDFor(userId: String) -> MCPeerID? {
        var peerIdentifier: MCPeerID?
        let peerIdentifiers = sessionsByPeerIDKey.keys
        if let index = peerIdentifiers.index(where: { $0.displayName == userId }) {
            peerIdentifier = peerIdentifiers[index]
        }
        
        return peerIdentifier
    }

    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            let session = getSessionFor(peer: peerID)
            let accept = !session.connectedPeers.contains(peerID)
            invitationHandler(accept, session)
    }
    
    fileprivate func getSessionFor(peer: MCPeerID) -> MCSession {
        var session = sessionsByPeerIDKey[peer]
        if session == nil {
            session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
            session?.delegate = self
            sessionsByPeerIDKey[peer] = session
        }
        
        return session!
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }

    // MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let session = getSessionFor(peer: peerID)
        if !session.connectedPeers.contains(peerID) {
            delegate?.didFoundUser(userID: peerID.displayName, userName: info?[discoveryInfoUserNameKey])
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if let _ = sessionsByPeerIDKey[peerID] {
            sessionsByPeerIDKey.removeValue(forKey: peerID)
        }
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    // MARK: - MCSessionDelegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {  }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let message = try peerMessageSerializer.deserializeMessageFrom(data: data) {
                delegate?.didRecieveMessage(text: message, fromUser: peerID.displayName, toUser: myPeerId.displayName)
            }
        }
        catch {
            //error handling
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
}
