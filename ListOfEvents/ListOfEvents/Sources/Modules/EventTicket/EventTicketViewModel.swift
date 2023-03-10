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
        let eventTicket = BehaviorRelay<EventTicketModel?>(value: nil)
    }
}

final class EventTicketViewModel: EventTicketViewModelProtocol {
    let bindings = Bindings()

    init(for event: EventTicketModel) {
        bindings.eventTicket.accept(event)
    }
}
