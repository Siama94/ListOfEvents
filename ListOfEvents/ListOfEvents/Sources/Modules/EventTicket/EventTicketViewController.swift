//
//  EventTicketViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import RxSwift
import RxCocoa

final class EventTicketViewController: RxBaseViewController<EventTicketView> {

    private var viewModel: EventTicketViewModelProtocol

    init(viewModel: EventTicketViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {

        viewModel.bindings.eventTicket
            .filterNil()
            .bind(to: contentView.eventTicket)
            .disposed(by: disposeBag)

        contentView.closeViewPublisher
            .mapToVoid()
            .bind(to: Binder<Void>(self) { viewController, _ in
                viewController.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
