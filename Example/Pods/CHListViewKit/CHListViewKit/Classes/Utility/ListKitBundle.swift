//
//  Bundle.swift
//  CHListViewKit
//
//  Created by RickWang on 2023/2/23.
//

import Foundation

struct CHListViewKitAssets {
    static let bundle: Bundle = {
        Bundle.main.url(forResource: "CHListViewKitAssets", withExtension: "bundle")
            .flatMap(Bundle.init(url:)) ?? Bundle.main
    }()
}

