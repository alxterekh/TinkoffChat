//
//  Assembly.swift
//  TinkoffChat
//
//  Created by Alexander on 19/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class ServiceAssembly {
    
    static let coreDataStack = CoreDataStack()
    static let serializer = PeerMessageSerializer()
    
    static func profileDataService() -> ProfileDataStorage {
        
        return ProfileDataService(with: coreDataStack)
    }
    
    static var communicatorService = { () -> CommunicatorSupervisor in 

        let multipeerCommunicator = MultipeerCommunicator(with: serializer, name: ServiceAssembly.fetchAppUserName())
        let conversationStorage = ConversationStorageService(with: coreDataStack)
        
        return CommunicatorSupervisor(with: multipeerCommunicator, storage: conversationStorage)
    }()
    
    fileprivate static func fetchAppUserName() -> String {
        var name = UIDevice.current.name
        if let context = ServiceAssembly.coreDataStack.mainContext,
            let user = User.fetchAppUser(in: context),
            let userName = user.name {
            name = userName
        }
        return name
    }
    
    static func imageLoaderService() -> ImageLoader {
        let requestSender = RequestSender()
    
        return ImageLoaderService(requestSender: requestSender)
    }
}
