//
//  RxExtensions.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 15/07/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation
import RxSwift

public protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

public extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}
