//
//  EventDetailsModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import Foundation

struct EventDetailsModel: Decodable, Hashable {
    let guid: String
    let event: String
    let ticketPrice: Double
    let date: String
    let email: String
    let description: String
    let phone: String
    let address: String
}
