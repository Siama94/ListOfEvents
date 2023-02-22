//
//  AppCoordinator.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol AppCoordinatorProtocol {
    func start()
}

final class AppCoordinator: AppCoordinatorProtocol {

    private let bag = DisposeBag()

    private var rootViewController: UINavigationController?
    private let window: UIWindow?
    private var networkManager: NetworkManagerProtocol!
    
    //Swinject, EasyDI
    
    init(window: UIWindow?) {
        self.window = window
        self.networkManager = NetworkManager()
    }

    func start() {
        guard let window = window else { return }
        rootViewController = UINavigationController(rootViewController: presentListEventsViewController())
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    private func presentListEventsViewController() -> ListEventsViewController {
        let listEventsViewModel = ListEventsViewModel(networkManager: networkManager)
        let listEventsViewController = ListEventsViewController(viewModel: listEventsViewModel)

        listEventsViewModel.moduleOutput.openEventDetails
            .filterNil()
            .subscribe(onNext: { [weak self] eventId in
                self?.presentEventDetails(for: eventId, from: listEventsViewController)
        }).disposed(by: bag)

        return listEventsViewController
    }

    private func presentEventDetails(for eventId: String, from viewController: UIViewController) {
        let eventDetailsViewModel = EventDetailsViewModel(for: eventId, with: networkManager)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel)
        viewController.show(eventDetailsViewController, sender: nil)

        eventDetailsViewModel.moduleOutput.openTicket
            .filterNil()
            .subscribe(onNext: { [weak self] model in
                self?.presentEventTicket(for: model, from: eventDetailsViewController)
        }).disposed(by: bag)
    }

    private func presentEventTicket(for event: EventTicketModel, from viewController: UIViewController) {
        let eventTicketViewModel = EventTicketViewModel(for: event)
        let eventTicketViewController = EventTicketViewController(viewModel: eventTicketViewModel)
        viewController.present(eventTicketViewController, animated: true, completion: nil)
    }
}
