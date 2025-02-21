//
//  NukeOptions.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/20/25.
//

import Foundation
import Nuke

struct NukeOptions {
    // loading options used by Nuke
    static let options = ImageLoadingOptions(placeholder: UIImage(named: "cardplaceholer"), transition: .fadeIn(duration: 0.33), failureImage: UIImage(named: "cardplaceholder"))
}
