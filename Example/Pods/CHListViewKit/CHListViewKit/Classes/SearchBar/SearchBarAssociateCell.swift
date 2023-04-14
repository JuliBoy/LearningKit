//
//  SearchBarAssociateCell.swift
//  OASwift
//
//  Created by RickWang on 2023/2/23.
//

import Foundation
import JiuFoundation

@objcMembers
public class SearchBarAssociateCell: UITableViewCell {
    
    // MARK: - Property
    
    public var style: SearchBarStyle = OASearchBarStyle()
    
    public lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.font = style.associateListCellFont
        label.textColor = style.associateListCellTextColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSubViews()
    }
    
    public func initSubViews() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.autoMake { maker in
            maker.left(inset: style.associateListCellTextMarginLeft)
            maker.centerY()
        }
    }
    
    // MARK: - Method
    
    public func reloadCell(_ model: SearchValueModel) {
        if let associateString = model.associatedString {
            let range = (model.key as NSString).range(of: associateString)
            if range.location != NSNotFound {
                let attrString = NSMutableAttributedString(string: model.key, attributes: [NSAttributedString.Key.font : style.associateListCellFont, NSAttributedString.Key.foregroundColor: style.associateListCellTextColor])
                attrString.addAttributes([NSAttributedString.Key.foregroundColor : style.associateListCellHighLightTextColor], range: range)
                //AttributedBuilder(model.key).font(style.associateListCellFont).color(style.associateListCellTextColor).build()
                self.titleLabel.attributedText = attrString
            }
        } else {
            self.titleLabel.text = model.key
        }
    }
    
    // MARK: - Action
    
}
