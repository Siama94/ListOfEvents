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
        let networkIndicatorPublisher = BehaviorRelay<Bool>(value: false)
        let endRefreshEvents = BehaviorRelay<Void?>(value: nil)
    }

    struct Commands {
        let sortListEvents = BehaviorRelay<KindSorting>(value: .none)
        let filterListEvents = BehaviorRelay<FilterOfList>(value: .allEvents)
        let openEventDetails = BehaviorRelay<String?>(value: nil)
        let startRefreshEvents = BehaviorRelay<Void?>(value: nil)
    }

    struct ModuleOutput {
        let openEventDetails = BehaviorRelay<String?>(value: nil)
    }
}

final class ListEventsViewModel: ListEventsViewModelProtocol {

    // MARK: - Settings
    
    let disposeBag = DisposeBag()
    let bindings = Bindings()
    let commands = Commands()
    let moduleOutput = ModuleOutput()
    let networkManager: NetworkManagerProtocol?

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        bindings.networkIndicatorPublisher.accept(true)
        self.getListEvents()
        configure(commands: commands, bindings: bindings)
    }

    // MARK: - Configure

    private func configure(commands: Commands, bindings: Bindings) {
        
        commands.startRefreshEvents
            .bind(to: Binder<Void?>(self) { [weak self] viewModel, _ in
                self?.getListEvents()
            }).disposed(by: disposeBag)

        commands.sortListEvents
            .bind(to: Binder<KindSorting>(self) { [weak self] viewModel, kindSort in
                self?.filterAndSortListEvents(by: .init(sort: kindSort,
                                                        filter: commands.filterListEvents.value)
                )
            }).disposed(by: disposeBag)

        commands.filterListEvents
            .bind(to: Binder<FilterOfList>(self) { [weak self] viewModel, kindFilter in
                self?.filterAndSortListEvents(by: .init(sort: commands.sortListEvents.value,
                                                        filter: kindFilter)
                )
            }).disposed(by: disposeBag)
        
        commands.openEventDetails
            .bind(to: moduleOutput.openEventDetails)
            .disposed(by: disposeBag)
    }

    private func getListEvents() {
        networkManager?.getListEvents()
            .subscribe(onNext: { [weak self] events in
                guard let self = self else { return }
                self.bindings.endRefreshEvents.accept(())
                let events: [EventModel] = events
                let eventsWithData = events.map { EventModelWithDate(from: $0) }
                self.bindings.listEventsItems.accept(eventsWithData)
                self.filterAndSortListEvents(by: .init(sort: self.commands.sortListEvents.value,
                                                        filter:  self.commands.filterListEvents.value)
                )
                self.bindings.networkIndicatorPublisher.accept(false)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods

    private func filterAndSortListEvents(by state: StateOfList) {

        let deafultEvents = bindings.listEventsItems.value
        var events = [EventModelWithDate]()

        switch (state.sort, state.filter) {
    
        case (.none, .allEvents):
            events = deafultEvents
        case (.none, .upcomingEvents):
            events = deafultEvents.filter({ $0.date >= Date() })

        case (.priceMax, .allEvents):
            events = deafultEvents.sorted(by: {$0.ticketPrice  > $1.ticketPrice})
        case (.priceMax, .upcomingEvents):
            events = deafultEvents.filter({ $0.date >= Date() }).sorted(by: {$0.ticketPrice > $1.ticketPrice})

        case (.priceMin, .allEvents):
            events = deafultEvents.sorted(by: {$0.ticketPrice < $1.ticketPrice})
        case (.priceMin, .upcomingEvents):
            events = deafultEvents.filter({ $0.date >= Date() }).sorted(by: {$0.ticketPrice < $1.ticketPrice})

        case (.date, .allEvents):
            events = deafultEvents.sorted(by: {$0.date > $1.date})
        case (.date, .upcomingEvents):
            events = deafultEvents.filter({ $0.date >= Date() }).sorted(by: {$0.date > $1.date})
        }

        let eventsSection = events.mapToListEventsSections()
        bindings.listEventsSection.accept(eventsSection)
    }
}
