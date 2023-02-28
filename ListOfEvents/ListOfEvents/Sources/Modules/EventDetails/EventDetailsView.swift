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

    let eventDetails = BehaviorRelay<EventDetailsModel?>(value: nil)
    let buttonPublisher = PublishSubject<EventDetailsModel>()
    let networkIndicatorPublisher = BehaviorRelay<Bool>(value: false)

    // MARK: - Configure

    private var eventItem: EventDetailsModel?

    private func configure(from model: EventDetailsModel) {
        eventItem = eventDetails.value

        eventTitle.text = model.event
        descriptionTitle.text = "- " + (model.description) + "."
        addresstTitle.text = model.address
        phoneTitle.text = model.phone

        let date = model.date.dateFromString
        dateTitle.text = date?.stringFromDate

        setButton(for: model)
    }

    // MARK: - Views

    private lazy var eventTitle = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .boldSystemFont(ofSize: Metric.eventTitleFontSize)
    }

    private lazy var descriptionTitle = UILabel().then {
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = Metric.descriptionNumberOfLines
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

    private lazy var payButton = UIButton().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: Metric.payButtonFontSize)
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.white, for: .normal)
    }

    private lazy var networkIndicator = UIActivityIndicatorView().then {
        $0.isHidden = true
    }

    // MARK: - Methods

    private func setButton(for event: EventDetailsModel) {
        payButton.setTitle("Buy for \(event.ticketPrice) $", for: .normal)
        payButton.backgroundColor = .systemIndigo
    }

    private func setNetworkIndicator(isLoading: Bool) {
        if isLoading {
            networkIndicator.startAnimating()
            networkIndicator.isHidden = false
        } else {
            networkIndicator.stopAnimating()
            networkIndicator.isHidden = true
        }
    }


    // MARK: - Settings

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(eventTitle)
        addSubview(descriptionTitle)
        addSubview(dateTitle)
        addSubview(addresstTitle)
        addSubview(phoneTitle)
        addSubview(networkIndicator)
        addSubview(payButton)
    }

    override func setupLayout() {
        super.setupLayout()

        eventTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
        }

        descriptionTitle.snp.makeConstraints {
            $0.top.equalTo(eventTitle.snp.bottom).offset(Metric.viewOffset)
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
            $0.trailing.equalToSuperview().inset(Metric.viewOffset)
        }

        dateTitle.snp.makeConstraints {
            $0.top.equalTo(descriptionTitle.snp.bottom).offset(Metric.viewOffset)
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
        }

        addresstTitle.snp.makeConstraints {
            $0.top.equalTo(dateTitle.snp.bottom).offset(Metric.viewOffset)
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
        }

        phoneTitle.snp.makeConstraints {
            $0.top.equalTo(addresstTitle.snp.bottom).offset(Metric.viewOffset)
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
        }

        networkIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(payButton.snp.top).offset(Metric.networkIndicatorBottomOffset)
        }

        payButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
            $0.trailing.equalToSuperview().inset(Metric.viewOffset)
            $0.height.equalTo(Metric.payButtonHeight)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Metric.payButtonBottomInset)
        }
    }

    override func setupBinding() {
        super.setupBinding()

        eventDetails.filterNil()
            .bind(to: Binder<EventDetailsModel>(self) { view, eventDetails in
                view.configure(from: eventDetails)
            }).disposed(by: disposeBag)

        payButton.rx.tap
            .map { [unowned self] in self.eventItem }
            .filterNil()
            .bind(to: buttonPublisher)
            .disposed(by: disposeBag)

        networkIndicatorPublisher
            .bind(to: Binder<Bool>(self) { view, isLoading in
                view.setNetworkIndicator(isLoading: isLoading)
            }).disposed(by: disposeBag)
    }
}

// MARK: - Constants
extension EventDetailsView {
    enum Metric {
        static let viewOffset: CGFloat = 16
        static let eventTitleFontSize: CGFloat = 25
        static let descriptionNumberOfLines: Int = 0
        static let networkIndicatorBottomOffset: CGFloat = -20
        static let payButtonFontSize: CGFloat = 17
        static let payButtonHeight: CGFloat = 60
        static let payButtonBottomInset: CGFloat = 30
    }
}
