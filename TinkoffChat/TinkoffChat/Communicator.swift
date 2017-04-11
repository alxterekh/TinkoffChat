//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Alexander on 08/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?)
    weak var delegate : MultipeerCommunicatorDelegate? {get set}
    var online: Bool {get set}
}
