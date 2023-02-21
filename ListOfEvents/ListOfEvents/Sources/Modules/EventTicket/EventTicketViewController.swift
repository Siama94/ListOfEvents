//
//  EventTicketViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

final class EventTicketViewController: RxBaseViewController<EventTicketView> {

    private var viewModel: EventTicketViewModelProtocol?

    convenience init(viewModel: EventTicketViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)
    }

    private func configure(viewModel: EventTicketViewModelProtocol?) {

        guard let viewModel = viewModel else { return }

        viewModel.bindings.eventTicket
            .filterNil()
            .bind(to: contentView.eventTicket)
            .disposed(by: disposeBag)
    }
}
