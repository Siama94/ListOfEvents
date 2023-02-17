//
//  EventModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import Foundation

struct EventModel: Codable, Hashable {
    var id: String
    var title: String
    var date: String
    var price: Double
    var paymentStatus: PaymentStatus
}

extension Array where Element == EventModel {

    func mapToListEventsSections() -> [ListEventsSectionModel] {
        guard !isEmpty else { return [] }
        return [.main(items: map(ListEventsItemModel.event))]
    }
}
