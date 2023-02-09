//
//  EventDetailsModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import Foundation

struct EventDetailsModel: Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let date: String
    let address: String
    let phone: String
    let price: Double
    let isPaid: Bool
}
