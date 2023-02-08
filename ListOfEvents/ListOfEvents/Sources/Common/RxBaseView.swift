//
//  RxBaseView.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import RxSwift
import UIKit

class RxBaseView: UIView {

    // MARK: - Reactive

    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        setupBinding()
        setupHierarchy()
        setupLayout()
        setupView()
    }

    // MARK: - Settings

    func setupBinding() { }
    func setupHierarchy() { }
    func setupLayout() { }
    func setupView() {
        backgroundColor = Color.backgroundColor
    }
}

fileprivate extension RxBaseView {
    enum Color {
        static let backgroundColor = UIColor.white
    }
}
