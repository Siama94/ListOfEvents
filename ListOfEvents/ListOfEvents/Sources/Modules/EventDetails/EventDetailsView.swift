//
//  EventDetailsView.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class EventDetailsView: RxBaseView {

    // MARK: - Configure

    let eventDetails = BehaviorRelay<EventDetailsModel?>(value: nil)
    var buttonPublisher = PublishSubject<EventDetailsModel>()
    var eventItem: EventDetailsModel?

    func configure(from model: EventDetailsModel) {
        eventItem = eventDetails.value

        eventTitle.text = model.event
        descriptionTitle.text = "- " + (model.description ?? "") + "."
        addresstTitle.text = model.address
        phoneTitle.text = model.phone

        let date = model.date?.dateFromString
        dateTitle.text = date?.stringFromDate

        setButton(for: model)

    }

    // MARK: - Views

    private lazy var eventTitle = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .boldSystemFont(ofSize: 25)
    }

    private lazy var descriptionTitle = UILabel().then {
        $0.textColor = .black
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
    }

    private lazy var dateTitle = UILabel().then {
        $0.textColor = .black
    }

    private lazy var addresstTitle = UILabel().then {
        $0.textColor = .black
    }

    private lazy var phoneTitle = UILabel().then {
        $0.textColor = .black
    }

    private lazy var buyButton = UIButton().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.white, for: .normal)
    }

    private func setButton(for event: EventDetailsModel) {
//        switch event.paymentStatus {
//        case .paid:
//            buyButton.setTitle("Open ticket", for: .normal)
//            buyButton.backgroundColor = .darkGray
//        case .notPaid:
//            buyButton.setTitle("Buy for \(event.price) $", for: .normal)
//            buyButton.backgroundColor = .systemIndigo
//        }

        guard let price = event.ticketPrice else { return }
        buyButton.setTitle("Buy for \(price) $", for: .normal)
        buyButton.backgroundColor = .systemIndigo
    }


    // MARK: - Settings

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(eventTitle)
        addSubview(buyButton)
        addSubview(descriptionTitle)
        addSubview(dateTitle)
        addSubview(addresstTitle)
        addSubview(phoneTitle)


    }

    override func setupLayout() {
        super.setupLayout()

//        stackView.snp.makeConstraints {
//            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
//        }

        eventTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
        }

        buyButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
            $0.top.equalTo(eventTitle.snp.bottom).offset(16)
        }

        descriptionTitle.snp.makeConstraints {
            $0.top.equalTo(buyButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }

        dateTitle.snp.makeConstraints {
            $0.top.equalTo(descriptionTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        addresstTitle.snp.makeConstraints {
            $0.top.equalTo(dateTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        phoneTitle.snp.makeConstraints {
            $0.top.equalTo(addresstTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
    }

    override func setupBinding() {
        super.setupBinding()

        eventDetails.filterNil()
            .bind(to: Binder<EventDetailsModel>(self) { view, eventDetails in
                view.configure(from: eventDetails)
            }).disposed(by: disposeBag)

        buyButton.rx.tap
            .map { [unowned self] in self.eventItem }
            .filterNil()
            .bind(to: buttonPublisher)
            .disposed(by: disposeBag)

    }
}

// MARK: - Constants

extension EventDetailsView {

    enum Metric {
    }
}
