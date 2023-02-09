//
//  RxExtension.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 08.02.2023.
//

import RxSwift

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

protocol OptionalType {
    associatedtype Wrapped

    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension ObservableType where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}
