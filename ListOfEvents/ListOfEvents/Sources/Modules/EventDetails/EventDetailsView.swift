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

    func configure(from model: EventDetailsModel) {

        let price = eventDetails.value?.price

        eventTitle.text = model.title
        descriptionTitle.text = model.description
        dateTitle.text = model.date
        addresstTitle.text = model.address
        phoneTitle.text = model.phone
        buyButton.setTitle("Buy for \(String(describing: price ?? 0)) $", for: .normal)
    }

    // MARK: - Views

    private lazy var eventTitle = UILabel().then {
        $0.textColor = .black
    }

    private lazy var descriptionTitle = UILabel().then {
        $0.textColor = .black
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
        var eventDetails = eventDetails.value
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.white, for: .normal)
    }

    private lazy var stackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 20
        $0.distribution = .equalSpacing
    }


    // MARK: - Settings

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(stackView)
        stackView.addArrangedSubview(eventTitle)
        stackView.addArrangedSubview(descriptionTitle)
        stackView.addArrangedSubview(dateTitle)
        stackView.addArrangedSubview(addresstTitle)
        stackView.addArrangedSubview(phoneTitle)
        stackView.addArrangedSubview(buyButton)

    }

    override func setupLayout() {
        super.setupLayout()

        stackView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
        }
    }

    override func setupBinding() {
        super.setupBinding()

        eventDetails.filterNil()
            .bind(to: Binder<EventDetailsModel>(self) { view, eventDetails in
                view.configure(from: eventDetails)
            }).disposed(by: disposeBag)

    }
}

// MARK: - Constants

extension EventDetailsView {

    enum Reusable {
    }
}
