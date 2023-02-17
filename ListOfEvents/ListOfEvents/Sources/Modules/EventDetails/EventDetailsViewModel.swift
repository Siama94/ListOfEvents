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
        let updateStatus = BehaviorRelay<Void?>(value: nil)
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
                print(event.paymentStatus)
                switch event.paymentStatus {
                case .paid:
                    self?.moduleOutput.getTicket.accept(event)
                case .notPaid:
                    self?.networkManager?.buyEventTicket(for: event)
                }
            }).disposed(by: disposeBag)

        networkManager?.getTicket
            .filterNil()
            .subscribe(onNext: { [weak self] event in
                self?.moduleOutput.getTicket.accept(event)
            }).disposed(by: disposeBag)

        commands.updateStatus
            .filterNil()
            .bind(to: Binder<Void?>(self) { [weak self] viewModel, void in
                self?.getNewStatus()
            }).disposed(by: disposeBag)

    }

    func getNewStatus() {
        let event = bindings.eventDetails.value
        guard let ind = EventStorage.storageEventDetailsModel.firstIndex(where: { $0.id == event?.id ?? ""}) else { return }
        bindings.eventDetails.accept(EventStorage.storageEventDetailsModel[ind])
    }
}
