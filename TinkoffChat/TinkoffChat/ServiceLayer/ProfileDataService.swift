//
//  ProfileDataService.swift
//  TinkoffChat
//
//  Created by Alexander on 17/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ProfileDataService {
    
    let gcdBasedDataOperator = GCDBasedDataOperator()
    let operationBasedDataOperator = OperationBasedDataOperator()
    
    func getRandomDataStore() -> DataStore {
        let dataOperators = [gcdBasedDataOperator, operationBasedDataOperator] as [DataStore]
        return dataOperators[Int(arc4random_uniform(2))]
    }
}
