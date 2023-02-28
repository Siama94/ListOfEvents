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

    private var viewModel: EventDetailsViewModelProtocol

    init(viewModel: EventDetailsViewModel) {
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

    // MARK: - Configure

    private func configure() {

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


