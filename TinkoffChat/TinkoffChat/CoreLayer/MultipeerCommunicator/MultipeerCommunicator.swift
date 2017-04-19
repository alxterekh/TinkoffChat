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
    weak var delegate : MultipeerCommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol MultipeerCommunicatorDelegate : class {
    func didFindUser(userID: String, userName: String?)
    func didLooseUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String)
}

class MultipeerCommunicator:NSObject, Communicator {
    
    fileprivate let serviceType = "tinkoff-chat"
    fileprivate let discoveryInfoUserNameKey = "userName"
    
    fileprivate let myPeerId = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    
    fileprivate var serviceBrowser: MCNearbyServiceBrowser
    fileprivate var serviceAdvertiser: MCNearbyServiceAdvertiser
    
    fileprivate var sessionsByPeerIDKey = [MCPeerID : MCSession]()
    
    fileprivate let peerMessageSerializer = PeerMessageSerializer()
    
    weak var delegate : MultipeerCommunicatorDelegate?
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
        // TODO: implement
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
        return sessionsByPeerIDKey.keys.filter { $0.displayName == userId }.first
    }
    
    fileprivate func getSessionFor(peer: MCPeerID) -> MCSession {
        if let session = sessionsByPeerIDKey[peer] {
            return session
        }
        
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessionsByPeerIDKey[peer] = session
        return session
    }
    
    fileprivate func notifyDelegate(block: @escaping (_ delegate: MultipeerCommunicatorDelegate) -> ()) {
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                block(delegate)
            }
        }
    }
}

extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    fileprivate static let peerInvitationTimeout: TimeInterval = 30
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        let session = getSessionFor(peer: peerID)
        if !session.connectedPeers.contains(peerID) {
            notifyDelegate{ $0.didFindUser(userID: peerID.displayName, userName: info?[self.discoveryInfoUserNameKey]) }
            browser.invitePeer(peerID,
                               to: session,
                               withContext: nil,
                               timeout: MultipeerCommunicator.peerInvitationTimeout)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if let _ = sessionsByPeerIDKey[peerID] {
            sessionsByPeerIDKey.removeValue(forKey: peerID)
        }
        
        notifyDelegate{ $0.didLooseUser(userID: peerID.displayName) }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        notifyDelegate { $0.failedToStartBrowsingForUsers(error: error) }
    }
}

extension MultipeerCommunicator : MCNearbyServiceBrowserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = getSessionFor(peer: peerID)
        let accept = !session.connectedPeers.contains(peerID)
        invitationHandler(accept, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        notifyDelegate{ $0.failedToStartAdvertising(error: error) }
    }
}

extension MultipeerCommunicator : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {  }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let message = try peerMessageSerializer.deserializeMessageFrom(data: data) {
                notifyDelegate{ $0.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: self.myPeerId.displayName) }
            }
        }
        catch {
            print("\(error)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
}
