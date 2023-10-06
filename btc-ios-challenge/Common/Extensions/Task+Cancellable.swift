//
//  Task+Cancellable.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 01/10/23.
//

import Combine

extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}
