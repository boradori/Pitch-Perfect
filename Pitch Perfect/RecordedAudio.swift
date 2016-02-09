//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Youngsun Paik on 1/24/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class RecordedAudio {
    var filePathURL: NSURL!
    var title: String!
    // https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson6.html was the source of initialization in Swift
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}