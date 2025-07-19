//
//  String+Identifiable.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation

extension String: @retroactive Identifiable {
    public var id: String { self }
}
