//
//  EventTicketViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

class EventTicketViewController: RxBaseViewController<EventTicketView> {

    var viewModel: EventTicketViewModelProtocol?

    convenience init(viewModel: EventTicketViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
