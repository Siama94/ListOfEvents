//
//  EventTicketViewModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import RxSwift
import RxCocoa

protocol EventTicketViewModelProtocol {
    var bindings: EventTicketViewModel.Bindings { get }

}

extension EventTicketViewModel {

    struct Bindings {
        let eventTicket = BehaviorRelay<EventDetailsModel?>(value: nil)
    }
}

class EventTicketViewModel: EventTicketViewModelProtocol {
    var bindings = Bindings()


    init(for event: EventDetailsModel) {
        bindings.eventTicket.accept(event)
    }

    private func configure() {
    }
}
