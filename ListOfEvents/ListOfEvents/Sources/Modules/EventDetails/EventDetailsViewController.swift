//
//  EventDetailsViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

class EventDetailsViewController: RxBaseViewController<EventDetailsView> {

    var viewModel: EventDetailsViewModelProtocol?

    convenience init(viewModel: EventDetailsViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)
    }

    private func configure(viewModel: EventDetailsViewModelProtocol?) {

        guard let viewModel = viewModel else { return }

        viewModel.bindings.eventDetails
            .filterNil()
            .bind(to: contentView.eventDetails)
            .disposed(by: disposeBag)


    }
}


