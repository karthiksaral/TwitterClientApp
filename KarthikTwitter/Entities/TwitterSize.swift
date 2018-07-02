//
//  TwitterSize.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation
import UIKit

typealias JSON = [String: Any]
typealias TwitterSize = CGSize

let dateFormatter: DateFormatter = {
    var df = DateFormatter()
    df.dateFormat = "ccc MMM dd HH:mm:ss '+'zzzz yyyy"
    return df
}()
