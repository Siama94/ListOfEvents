//
//  EventTicketModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 20.02.2023.
//

import Foundation

struct EventTicketModel: Decodable, Hashable {
    let success: Bool
    let ticketPrice: Double
    let verificationImage: String
    let date: String
}
