//
//  RxTableViewDataSourcePrefetchingProxy.swift
//  RxCocoa
//
//  Created by Rowan Livingstone on 2/15/18.
//  Copyright © 2018 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift

@available(iOS 10.0, tvOS 10.0, *)
extension UITableView: HasPrefetchDataSource {
    public typealias PrefetchDataSource = UITableViewDataSourcePrefetching
}

@available(iOS 10.0, tvOS 10.0, *)
private let tableViewPrefetchDataSourceNotSet = TableViewPrefetchDataSourceNotSet()

@available(iOS 10.0, tvOS 10.0, *)
private final class TableViewPrefetchDataSourceNotSet
    : NSObject
    , UITableViewDataSourcePrefetching {

    func tableView(_ addressTableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}

}

@available(iOS 10.0, tvOS 10.0, *)
open class RxTableViewDataSourcePrefetchingProxy
    : DelegateProxy<UITableView, UITableViewDataSourcePrefetching>
    , DelegateProxyType {

    /// Typed parent object.
    public weak private(set) var addressTableView: UITableView?

    /// - parameter tableView: Parent object for delegate proxy.
    public init(addressTableView: ParentObject) {
        self.addressTableView = addressTableView
        super.init(parentObject: addressTableView, delegateProxy: RxTableViewDataSourcePrefetchingProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxTableViewDataSourcePrefetchingProxy(addressTableView: $0) }
    }

    private var _prefetchRowsPublishSubject: PublishSubject<[IndexPath]>?

    /// Optimized version used for observing prefetch rows callbacks.
    internal var prefetchRowsPublishSubject: PublishSubject<[IndexPath]> {
        if let subject = _prefetchRowsPublishSubject {
            return subject
        }

        let subject = PublishSubject<[IndexPath]>()
        _prefetchRowsPublishSubject = subject

        return subject
    }

    private weak var _requiredMethodsPrefetchDataSource: UITableViewDataSourcePrefetching? = tableViewPrefetchDataSourceNotSet

    /// For more information take a look at `DelegateProxyType`.
    open override func setForwardToDelegate(_ forwardToDelegate: UITableViewDataSourcePrefetching?, retainDelegate: Bool) {
        _requiredMethodsPrefetchDataSource = forwardToDelegate ?? tableViewPrefetchDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }

    deinit {
        if let subject = _prefetchRowsPublishSubject {
            subject.on(.completed)
        }
    }

}

@available(iOS 10.0, tvOS 10.0, *)
extension RxTableViewDataSourcePrefetchingProxy: UITableViewDataSourcePrefetching {
    /// Required delegate method implementation.
    public func tableView(_ addressTableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let subject = _prefetchRowsPublishSubject {
            subject.on(.next(indexPaths))
        }

        (_requiredMethodsPrefetchDataSource ?? tableViewPrefetchDataSourceNotSet).tableView(addressTableView, prefetchRowsAt: indexPaths)
    }
}

#endif

