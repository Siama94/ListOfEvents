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
        let listEventsItems = BehaviorRelay<[EventModelWithDate]>(value: [])
    }

    struct Commands {
        let sortListEvents = BehaviorRelay<KindSorting>(value: .none)
        let openEventDetails = BehaviorRelay<String?>(value: nil)
    }

    struct ModuleOutput {
        let openEventDetails = BehaviorRelay<String?>(value: nil)
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
                let eventsWithData = events.map { EventModelWithDate(from: $0) }
                self?.bindings.listEventsSection.accept(eventsWithData.mapToListEventsSections())
                self?.bindings.listEventsItems.accept(eventsWithData)
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
        var sortedEvents = [EventModelWithDate]()

        switch kindOfSorting {
        case .priceMax:
            sortedEvents = bindings.listEventsItems.value.sorted(by: {$0.ticketPrice ?? 0 > $1.ticketPrice ?? 0})
        case .priceMin:
            sortedEvents = bindings.listEventsItems.value.sorted(by: {$0.ticketPrice ?? 0 < $1.ticketPrice ?? 0})
        case .date:
            sortedEvents = bindings.listEventsItems.value.sorted(by: {$0.date ?? Date() > $1.date ?? Date() })
       default:
            break
        }

        let sortedEventsSection = sortedEvents.mapToListEventsSections()
        bindings.listEventsSection.accept(sortedEventsSection)
    }

}
