//
//  Array+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/06/2023.
//

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
