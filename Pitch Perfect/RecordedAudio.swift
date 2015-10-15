//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jim Nording on 09/10/15.
//  Copyright © 2015 Jim Nording. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}