//
//  Assembly.swift
//  TinkoffChat
//
//  Created by Alexander on 19/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class ServiceAssembly {
    
    static func profileDataService() -> ProfileDataStorage {
        let coreDataStack = CoreDataStack()
        
        return ProfileDataService(with: coreDataStack)
    }
    
    static func communicatorService() -> CommunicatorService {
        let serializer = PeerMessageSerializer()
        let multipeerCommunicator = MultipeerCommunicator(with: serializer)
        
        return CommunicatorManager(with: multipeerCommunicator)
    }
}
