//
//  CommonExtensions.swift
//  Atchaga
//
//  Created by Clpak on 30/04/2019.
//  Copyright © 2019 Atchaga. All rights reserved.
//

import UIKit

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
