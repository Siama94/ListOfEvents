//
//  ListEventsViewModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import RxSwift
import RxCocoa

protocol ListEventsViewModelProtocol {
    var bindings: ListEventsViewModel.Bindings { get }
    var commands: ListEventsViewModel.Commands { get }

}

extension ListEventsViewModel {

    struct Bindings {
        let listEventsSection = BehaviorRelay<[ListEventsSectionModel]>(value: [])
        let listEventsItems = BehaviorRelay<[EventModel]>(value: [])
    }

    struct Commands {
        let sortListEvents = BehaviorRelay<KindSorting>(value: .none)
        let openEventDetails = BehaviorRelay<EventModel?>(value: nil)
    }

    struct ModuleOutput {
        let openEventDetails = BehaviorRelay<EventModel?>(value: nil)
    }
}

class ListEventsViewModel: ListEventsViewModelProtocol {

    var disposeBag = DisposeBag()
    var bindings = Bindings()
    var commands = Commands()
    let moduleOutput = ModuleOutput()
    let networkManager: NetworkManagerProtocol?

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        networkManager.getListEvents()
        configure(commands: commands)
    }

    private func configure(commands: Commands) {

        networkManager?.listEventsItems
            .filterNil()
            .subscribe(onNext: { [weak self] events in
                self?.bindings.listEventsSection.accept(events.mapToListEventsSections())
                self?.bindings.listEventsItems.accept(events)
            }).disposed(by: disposeBag)


        commands.sortListEvents
            .bind(to: Binder<KindSorting>(self) { [weak self] viewModel, kindSort in
                self?.sortListEvents(by: kindSort)
            }).disposed(by: disposeBag)

        commands.openEventDetails
            .bind(to: moduleOutput.openEventDetails)
            .disposed(by: disposeBag)
    }

    
    // MARK: - Methods

    func sortListEvents(by kindOfSorting: KindSorting) {
        var sortedEvents = [EventModel]()

        switch kindOfSorting {
        case .priceMax:
            sortedEvents = bindings.listEventsItems.value.sorted(by: {$0.price > $1.price})
        case .priceMin:
            sortedEvents = bindings.listEventsItems.value.sorted(by: {$0.price < $1.price})
        default:
            break
        }

        let sortedEventsSection = sortedEvents.mapToListEventsSections()
        bindings.listEventsSection.accept(sortedEventsSection)
    }

}
