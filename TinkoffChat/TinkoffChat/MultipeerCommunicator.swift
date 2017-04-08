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

class MultipeerCommunicator: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, Communicator {
    
    fileprivate let serviceType = "tinkoff-chat"
    fileprivate let discoveryInfoUserNameKey = "userName"
    
    fileprivate let myPeerId = MCPeerID(displayName: UUID().uuidString)
    
    fileprivate var serviceBrowser: MCNearbyServiceBrowser?
    fileprivate var serviceAdvertiser: MCNearbyServiceAdvertiser?

    fileprivate var sessionsByPeerIDKey = [String : MCSession]()
    
    fileprivate let peerMessageSerializer = PeerMessageSerializer()
    
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
       
        return  [discoveryInfoUserNameKey : UIDevice.current.name]
    }
    
    fileprivate func configureServiceBrowser() {
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType:serviceType)
        serviceBrowser?.delegate = self
        serviceBrowser?.startBrowsingForPeers()
    }
    
    // MARK: - Communicator
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        if let session = sessionsByPeerIDKey[userID] {
            do {
                let serializedMessage = try peerMessageSerializer.serializeMessageWith(text: string)
                try session.send(serializedMessage, toPeers: [], with: .reliable )
                completionHandler?(true, nil)
            }
            catch {
                completionHandler?(false, error)
            }
        }
    }

    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Swift.Void) {
        
            let session = getSessionFor(peer: peerID)
            let accept = !session.connectedPeers.contains(peerID)
            invitationHandler(accept, session)
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
        if let session = sessionsByPeerIDKey[peerID.displayName] {
            sessionsByPeerIDKey.removeValue(forKey: peerID.displayName)
        }
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    // MARK: -
    
    fileprivate func getSessionFor(peer: MCPeerID) -> MCSession {
        var session = sessionsByPeerIDKey[peer.displayName]
        if session == nil {
            session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
            session?.delegate = self
            sessionsByPeerIDKey[peer.displayName] = session
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
        do {
            if let message = try peerMessageSerializer.deserializeMessageFrom(data: data) {
                 delegate?.didRecieveMessage(text: message, fromUser: "", toUser: "")   ////////
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
