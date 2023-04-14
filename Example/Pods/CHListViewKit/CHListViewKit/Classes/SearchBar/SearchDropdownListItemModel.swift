//
//  SearchDropdownListItemModel.swift
//  OASwift
//
//  Created by RickWang on 2023/2/22.
//

import Foundation

@objcMembers
public class SearchDropdownListItemModel : NSObject{
    
    public var key: String = ""
    
    public var value: String = ""
    
    public var selected: Bool = false
    
    public var inputHint: String = ""
    
    public var associated: Bool = true
}

@objcMembers
public class SearchValueModel: NSObject {
    
    public var key: String = ""
    
    public var value: String = ""
    
    public var associatedString: String?
}
