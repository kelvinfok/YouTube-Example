//
//  Model.swift
//  LBTA-YouTube
//
//  Created by kelvinfok on 13/4/17.
//  Copyright © 2017 kelvinfok. All rights reserved.
//

import UIKit

struct Video {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: Int?
    var updateDate: Date?
    
    var channel: Channel?
    
}

struct Channel {
    var name: String?
    var profileImageName: String?
}
