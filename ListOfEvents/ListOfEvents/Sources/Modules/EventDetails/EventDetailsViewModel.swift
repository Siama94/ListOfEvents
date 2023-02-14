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
    }

    struct Commands {
        let getTicket = PublishSubject<EventDetailsModel>()
    }

    struct ModuleOutput {
        let getTicket = BehaviorRelay<EventDetailsModel?>(value: nil)
    }
}

class EventDetailsViewModel: EventDetailsViewModelProtocol {

    var disposeBag = DisposeBag()
    var bindings = Bindings()
    var commands = Commands()
    var moduleOutput = ModuleOutput()
    let networkManager: NetworkManagerProtocol?

    init(for event: EventModel, with networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        networkManager.getEventDetails(for: event)
        configure(commands: commands)
    }

    private func configure(commands: Commands) {

        networkManager?.eventDetails
            .filterNil()
            .subscribe(onNext: { [weak self] eventDetails in
                self?.bindings.eventDetails.accept(eventDetails)
            }).disposed(by: disposeBag)

        commands.getTicket
            .bind(to: Binder<EventDetailsModel>(self) { [weak self] viewModel, event in
                switch event.paymentStatus {
                case .paid:
                    self?.moduleOutput.getTicket.accept(event)
                case .notPaid:
                    self?.networkManager?.buyEventTicket(for: event)
//                    self?.moduleOutput.getTicket.accept(a)

                }
            }).disposed(by: disposeBag)

//        networkManager?.getTicket
//            .filterNil()
//            .subscribe(onNext: { [weak self] event in
//                self?.moduleOutput.getTicket.accept(event)
//            }).disposed(by: disposeBag)
    }
}
