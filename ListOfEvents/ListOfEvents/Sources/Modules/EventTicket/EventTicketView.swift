//
//  EventTicketView.swift.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class EventTicketView: RxBaseView {

    let eventTicket = BehaviorRelay<EventTicketModel?>(value: nil)
    let closeViewPublisher = PublishSubject<Void>()

    // MARK: - Configure

    private func configure(from model: EventTicketModel) {
        let date = model.date.dateFromString
        dateTitle.text = "Date of payment: " + (date?.stringFromDate ?? "unknown")

        // TODO: - сделать, чтоб из полной строки делался
        let shortCode = String(model.verificationImage.prefix(20))
        verificationQR.image = generateQRCode(from: shortCode)
    }

    // MARK: - Views

    private lazy var containerView = UIView().then {
        $0.layer.cornerRadius = Metric.containerViewCornerRadius
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }

    private lazy var dateTitle = UILabel().then {
        $0.textColor = .black
    }

    private lazy var verificationQR = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Settings

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(containerView)
        containerView.addSubview(dateTitle)
        containerView.addSubview(verificationQR)
    }

    override func setupView() {
        super.setupView()
        backgroundColor = .clear
    }

    override func setupLayout() {
        super.setupLayout()

        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Metric.containerViewHeight)
        }

        dateTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Metric.dateTitleTopOffset)
        }

        verificationQR.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    override func setupBinding() {
        super.setupBinding()

        let tapView = UITapGestureRecognizer()
        addGestureRecognizer(tapView)

        tapView.rx.event.mapToVoid()
            .bind(to: closeViewPublisher)
            .disposed(by: disposeBag)
        
        eventTicket.filterNil()
            .bind(to: Binder<EventTicketModel>(self) { view, eventDetails in
                view.configure(from: eventDetails)
            }).disposed(by: disposeBag)
    }

    // MARK: - Methods

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: Metric.qrCodeScale, y: Metric.qrCodeScale)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}

// MARK: - Constants
extension EventTicketView {
    enum Metric {
        static let containerViewCornerRadius: CGFloat = 10
        static let containerViewHeight: CGFloat = 400
        static let dateTitleTopOffset: CGFloat = 16
        static let qrCodeScale: CGFloat = 10
    }
}

