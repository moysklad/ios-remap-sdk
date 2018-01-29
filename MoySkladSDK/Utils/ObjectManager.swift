//
//  ObjectManager.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 22.01.2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

public class ObjectManager<Element> {
    private(set) var current: [Element]
    public private(set) var deleted: [Element]
    public private(set) var added: [Element]
    public private(set) var updated: [Element]
    private(set) var filtered: [Element]
    
    let isEqual: (Element, Element) -> Bool
    
    public init(data: [Element], isEqual: @escaping (Element, Element) -> Bool) {
        current = data
        filtered = current
        deleted = [Element]()
        added = [Element]()
        updated = [Element]()
        self.isEqual = isEqual
    }
    
    func contains(_ value: Element) -> Bool {
        return current.contains(where: { isEqual($0, value) })
    }
    
    public func append(_ value: Element) {
        guard !contains(where: { isEqual($0, value) }) else { return }
        current.append(value)
        added.append(value)
        filtered = current
    }
    
    public func update(_ value: Element) {
        // если нет в списке - выходим
        guard let currentIndex = index(where: { isEqual($0, value) }) else { return }
        // если есть в списке добавленных - выходим
        guard !added.contains(where: { isEqual($0, value) }) else { return }
        
        if let updatedIndex = updated.index(where:{ isEqual($0, value) }) {
          updated[updatedIndex] = value
        } else {
            updated.append(value)
        }
        
        current[currentIndex] = value
        filtered = current
    }
    
    public func remove(_ value: Element) {
        guard let index = current.index(where: { isEqual($0, value) }) else { return }
        current.remove(at: index)
        
        // если объект был добавлен, то удаляем его из списка добавленных
        if let addedIndex = added.index(where: { isEqual($0, value) }) {
            added.remove(at: addedIndex)
        } else {
            // если объект был изменен, то удаляем его из списка измененных
            if let updatedIndex = updated.index(where: { isEqual($0, value) }) {
                updated.remove(at: updatedIndex)
            }
            
            // и добавляем в список удаленных
            deleted.append(value)
        }
        filtered = current
    }
    
    public func filter(_ isIncluded: (Element) -> Bool) {
        filtered = current.filter(isIncluded)
    }
    
    public func removeFilter() {
        filtered = current
    }
    
    public func dropDeleted(count: Int) {
        deleted = Array(deleted.dropFirst(count))
    }
    
    public func refreshUpdated(with data: [Element]) {
        data.forEach { updatedElement in
            if let currentIndex = current.index(where: { isEqual($0, updatedElement) }) {
                current[currentIndex] = updatedElement
            }
            
            if let updatedIndex = updated.index(where: { isEqual($0, updatedElement) }) {
                updated.remove(at: updatedIndex)
            }
        }
    }
    
    public func refreshAdded(with data: [Element]) {
        data.forEach { updatedElement in
            if let currentIndex = current.index(where: { isEqual($0, updatedElement) }) {
                current[currentIndex] = updatedElement
            }
            
            if let addedIndex = added.index(where: { isEqual($0, updatedElement) }) {
                added.remove(at: addedIndex)
            }
        }
    }
}

extension ObjectManager: Collection {
    public var startIndex: Int { return filtered.startIndex }
    public var endIndex: Int { return filtered.endIndex }
    
    public func index(after i: Int) -> Int {
        return filtered.index(after: i)
    }
    
    public subscript(index: Int) -> Element { get { return filtered[index] } }
}

