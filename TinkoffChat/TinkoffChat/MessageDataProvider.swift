//
//  MessageDataProvider.swift
//  TinkoffChat
//
//  Created by Alexander on 27/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class MessageDataProvider: NSObject {
    
    func createMessagesSampleData() -> [Message] {
        let firstMessage = Message()
        firstMessage.text = "L"
        let secondMessage = Message()
        secondMessage.text = "Lorem ipsum dolor sit amet, pe"
        let thirdMessage = Message()
        thirdMessage.text = "Lorem ipsum dolor sit amet, persecuti dissentias persequeris ut ius. Iudico evertitur accommodare usu ex, vel at atqui facer. Ferri adversarium ad quo, no cum similique constituam. Exerci intellegat reprimique an vel, est ei impetus sanctus vulputate, praesent scripserit liberavisse mel an. Est salu"
        
        return [firstMessage, secondMessage, secondMessage] as [Message]
    }

}
