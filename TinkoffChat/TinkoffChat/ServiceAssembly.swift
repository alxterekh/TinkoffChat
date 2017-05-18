//
//  Assembly.swift
//  TinkoffChat
//
//  Created by Alexander on 19/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class ServiceAssembly {
    
    static let coreDataStack = CoreDataStack()
    static let serializer = PeerMessageSerializer()
    
    static func profileDataService() -> ProfileDataStorage {
        
        return ProfileDataService(with: coreDataStack)
    }
    
    static var communicatorService = { () -> CommunicatorSupervisor in 

        let multipeerCommunicator = MultipeerCommunicator(with: serializer)
        let conversationStorage = ConversationStorageService(with: coreDataStack)
        
        return CommunicatorSupervisor(with: multipeerCommunicator, storage: conversationStorage)
    }()
    
    static func imageLoaderService() -> ImageLoader {
        let requestSender = RequestSender()
    
        return ImageLoaderService(requestSender: requestSender)
    }
}
