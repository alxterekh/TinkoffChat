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

struct NewMessage {
    
    fileprivate static let messageEventTypeKey = "eventType"
    fileprivate static let messageEventTypeDescription = "TextMessage"
    fileprivate static let messageIdKey = "messageId"
    fileprivate static let messageTextKey = "text"
    
    fileprivate static func generateMessageId() -> String {
        return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
    }
    
    static func createMessageWith(text: String) -> [String: String]  {
        
        return  [messageEventTypeKey : messageEventTypeDescription,
                 messageIdKey : generateMessageId(),
                 messageTextKey : text]
    }
}

class MultipeerCommunicator: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, Communicator {
    
    fileprivate let serviceType = "tinkoff-chat"
    fileprivate let discoveryInfoUserNameKey = "userName"
    
    fileprivate let myPeerId = MCPeerID(displayName: UUID().uuidString)
    
    fileprivate var serviceBrowser: MCNearbyServiceBrowser?
    fileprivate var serviceAdvertiser: MCNearbyServiceAdvertiser?

    fileprivate var sessionsByPeerIDKey = [String : MCSession]()
    
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
//        var discoveryInfo:Dictionary<String, String>?
//        if let myName = "Terekhov" {
//            discoveryInfo = [discoveryInfoUserNameKey : myName]
//        }
       
        return  [discoveryInfoUserNameKey : UIDevice.current.name]
    }
    
    fileprivate func configureServiceBrowser() {
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType:serviceType)
        serviceBrowser?.delegate = self
        serviceBrowser?.startBrowsingForPeers()
    }
    
    // MARK: - Communicator
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        let message = NewMessage.createMessageWith(text: string)
        let session = sessionsByPeerIDKey[userID]
        do {
            let serializedMessage = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            try session!.send(serializedMessage, toPeers: [], with: .reliable )
            completionHandler!(true, nil)
            
        }
        catch {
            completionHandler!(false, error)
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
        //should be removed
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    // MARK: -
    
    func getSessionFor(peer: MCPeerID) -> MCSession {
        
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
      //delegate?.didRecieveMessage(text: nil, fromUser: nil, toUser: nil)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
}
