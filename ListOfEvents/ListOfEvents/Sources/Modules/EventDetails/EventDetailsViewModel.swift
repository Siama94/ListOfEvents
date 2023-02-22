//
//  EventDetailsViewModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import RxSwift
import RxCocoa

protocol EventDetailsViewModelProtocol {
    var bindings: EventDetailsViewModel.Bindings { get }
    var commands: EventDetailsViewModel.Commands { get }
}

extension EventDetailsViewModel {

    struct Bindings {
        let eventDetails = BehaviorRelay<EventDetailsModel?>(value: nil)
        let networkIndicatorPublisher = BehaviorRelay<Bool>(value: false)
    }

    struct Commands {
        let getTicket = PublishSubject<EventDetailsModel>()
    }

    struct ModuleOutput {
        let openTicket = BehaviorRelay<EventTicketModel?>(value: nil)
    }
}

final class EventDetailsViewModel: EventDetailsViewModelProtocol {

    // MARK: - Settings

    let disposeBag = DisposeBag()
    let bindings = Bindings()
    let commands = Commands()
    let moduleOutput = ModuleOutput()

    let networkManager: NetworkManagerProtocol?

    init(for eventId: String, with networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        networkManager.getEventDetails(for: eventId)
        configure(commands: commands, bindings: bindings)
    }

    // MARK: - Configure
    
    private func configure(commands: Commands, bindings: Bindings) {
        networkManager?.eventDetails
            .filterNil()
            .subscribe(onNext: { eventDetails in
                bindings.eventDetails.accept(eventDetails)
            }).disposed(by: disposeBag)

        commands.getTicket
            .bind(to: Binder<EventDetailsModel>(self) { [weak self] viewModel, event in
                bindings.networkIndicatorPublisher.accept(true)
                self?.networkManager?.buyEventTicket(for: event)
            }).disposed(by: disposeBag)

        networkManager?.openTicket
            .filterNil()
            .subscribe(onNext: { [weak self] event in
                bindings.networkIndicatorPublisher.accept(false)
                self?.moduleOutput.openTicket.accept(event)
            }).disposed(by: disposeBag)

    }
}
