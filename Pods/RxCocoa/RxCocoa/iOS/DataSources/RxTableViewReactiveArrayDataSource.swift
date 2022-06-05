//
//  RxTableViewReactiveArrayDataSource.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 6/26/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift

// objc monkey business
class _RxTableViewReactiveArrayDataSource
    : NSObject
    , UITableViewDataSource {
    
    func numberOfSections(in addressTableView: UITableView) -> Int {
        1
    }
   
    func _tableView(_ addressTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ addressTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _tableView(addressTableView, numberOfRowsInSection: section)
    }

    fileprivate func _tableView(_ addressTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        rxAbstractMethod()
    }

    func tableView(_ addressTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _tableView(addressTableView, cellForRowAt: indexPath)
    }
}


class RxTableViewReactiveArrayDataSourceSequenceWrapper<Sequence: Swift.Sequence>
    : RxTableViewReactiveArrayDataSource<Sequence.Element>
    , RxTableViewDataSourceType {
    typealias Element = Sequence

    override init(cellFactory: @escaping CellFactory) {
        super.init(cellFactory: cellFactory)
    }

    func tableView(_ addressTableView: UITableView, observedEvent: Event<Sequence>) {
        Binder(self) { tableViewDataSource, sectionModels in
            let sections = Array(sectionModels)
            tableViewDataSource.tableView(addressTableView, observedElements: sections)
        }.on(observedEvent)
    }
}

// Please take a look at `DelegateProxyType.swift`
class RxTableViewReactiveArrayDataSource<Element>
    : _RxTableViewReactiveArrayDataSource
    , SectionedViewDataSourceType {
    typealias CellFactory = (UITableView, Int, Element) -> UITableViewCell
    
    var itemModels: [Element]?
    
    func modelAtIndex(_ index: Int) -> Element? {
        itemModels?[index]
    }

    func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.item] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        return item
    }

    let cellFactory: CellFactory
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
    override func _tableView(_ addressTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemModels?.count ?? 0
    }
    
    override func _tableView(_ addressTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellFactory(addressTableView, indexPath.item, itemModels![indexPath.row])
    }
    
    // reactive
    
    func tableView(_ addressTableView: UITableView, observedElements: [Element]) {
        self.itemModels = observedElements
        
        addressTableView.reloadData()
    }
}

#endif
