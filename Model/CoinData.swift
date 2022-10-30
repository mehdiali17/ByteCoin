//
//  CoinDate.swift
//  ByteCoin
//
//  Created by Mehdi Ali on 23/7/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
    var roundedRate: String {
        var r = rate * 10
        r.round()
        r = r/10
        return String(r)
    }
}
