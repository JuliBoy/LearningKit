//
//  SearchTestController.swift
//  OASwift
//
//  Created by RickWang on 2023/2/22.
//

import Foundation
import UIKit
import JiuFoundation

@objc
public class SearchTestController: UIViewController {
    
    public var searchBar: SearchBarView = SearchBarView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
    }
    
}
