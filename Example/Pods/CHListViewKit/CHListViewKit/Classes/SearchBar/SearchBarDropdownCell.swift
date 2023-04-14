//
//  SearchBarDropdownCell.swift
//  OASwift
//
//  Created by RickWang on 2023/2/23.
//

import Foundation
import UIKit
import JiuFoundation

@objc
public class SearchBarDropdownCell: UITableViewCell {
    
    // MARK: - Property
    let titleLabel: UILabel = UILabel()
    
    public var style:SearchBarStyle = OASearchBarStyle()
    
    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    public func initSubViews() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        titleLabel.textColor = OASearchBarStyle().dropdownListCellTextColor
        titleLabel.font = OASearchBarStyle().dropdownListCellFont
        titleLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(titleLabel)
        
        titleLabel.autoMake { maker in
            maker.edges(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    // MARK: - Method
    public func reloadCell(_ model: SearchDropdownListItemModel) {
        titleLabel.text = model.key
        if (model.selected) {
            titleLabel.textColor = style.dropdownListCellSelectedTextColor
            titleLabel.font = style.dropdownListCellSelectedFont
        } else {
            titleLabel.textColor = style.dropdownListCellTextColor
            titleLabel.font = style.dropdownListCellFont
        }
    }
    
}
