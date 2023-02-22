//
//  EventDetailsViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class EventDetailsViewController: RxBaseViewController<EventDetailsView> {

    // MARK: - Settings

    private var viewModel: EventDetailsViewModelProtocol?

    convenience init(viewModel: EventDetailsViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)
    }

    // MARK: - Configure

    private func configure(viewModel: EventDetailsViewModelProtocol?) {

        guard let viewModel = viewModel else { return }

        viewModel.bindings.eventDetails
            .filterNil()
            .bind(to: contentView.eventDetails)
            .disposed(by: disposeBag)

        contentView.buttonPublisher
            .bind(to: viewModel.commands.getTicket)
            .disposed(by: disposeBag)

        viewModel.bindings.networkIndicatorPublisher
            .bind(to: contentView.networkIndicatorPublisher)
            .disposed(by: disposeBag)
    }
}


