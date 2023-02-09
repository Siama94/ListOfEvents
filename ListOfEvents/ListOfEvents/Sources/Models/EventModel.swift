//
//  EventModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import Foundation

struct EventModel: Codable, Hashable {
    let id: String
    let title: String
    let date: String
    let price: Double
    let paymentStatus: PaymentStatus
}

extension Array where Element == EventModel {

    func mapToListEventsSections() -> [ListEventsSectionModel] {
        guard !isEmpty else { return [] }
        return [.main(items: map(ListEventsItemModel.event))]
    }
}
