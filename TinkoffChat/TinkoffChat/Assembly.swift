//
//  Assembly.swift
//  TinkoffChat
//
//  Created by Alexander on 19/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class Assembly  {
    
    private func profileDataService() -> ProfileData {
        let store = FileBasedDataStore()
        let operationBasedDataStore =  OperationBasedDataOperator(with: store)
        let gcdBasedDataStore = GCDBasedDataOperator(with: store)
        
        return ProfileDataService(gcdBasedDataStore: gcdBasedDataStore, operationBasedDataStore: operationBasedDataStore)
        
    }
}
