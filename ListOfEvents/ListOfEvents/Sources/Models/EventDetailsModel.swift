//
//  EventDetailsModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import Foundation

struct EventDetailsModel: Codable, Hashable {
    var id: String
    var title: String
//    let description: String
//    let date: String
//    let address: String
//    let phone: String
//    let price: Double
    var description = ""
    var date = ""
    var address = ""
    var phone = ""
    var price = ""
    var paymentStatus: PaymentStatus

//    init(from event: EventModel) {
//        self.id = event.id
//        self.title = event.title
//        self.paymentStatus = event.paymentStatus
//    }
}
