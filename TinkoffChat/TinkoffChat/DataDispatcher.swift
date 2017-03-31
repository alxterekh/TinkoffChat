//
//  DataDispatcher.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class DataDispatcher: NSObject {
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func writeProfileToFile(_ profile: Profile) {
        
    }
    
    func saveImage(_ image: UIImage) {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("avatar.png")
            try? data.write(to: filename)
        }
    }
    
}
