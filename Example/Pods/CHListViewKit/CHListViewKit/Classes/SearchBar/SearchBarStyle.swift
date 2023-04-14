//
//  SearchBarStyle.swift
//  OASwift
//
//  Created by RickWang on 2023/2/22.
//

import Foundation
import UIKit
import JiuFoundation

/// 定义搜索框的样式协议
@objc
public protocol SearchBarStyle {
    
    /// 搜索条的背景颜色
    var barBackgroundColor: UIColor { get set }
    
    /// 输入框的背景颜色
    var inputBackgroundColor: UIColor { get set }
    
    /// 输入框距离搜索条的外边距
    var inputEdgeInsets: UIEdgeInsets { get set }
    
    /// 搜索提示字体
    var inputHintFont: UIFont { get set }
    
    /// 搜索提示字体颜色
    var inputHintTextColor: UIColor { get set }
    
    /// 输入框字体
    var inputFont: UIFont { get set }
    
    /// 输入框字体颜色
    var inputTextColor: UIColor { get set }
    
    /// 输入框距离左边的距离
    var inputMargingLeft: CGFloat { get set }
    
    /// 清除按钮的尺寸
    var cleartButtonIconSize: CGSize { get set }
    
    /// 清除按钮的图标
    var clearButtonIcon: UIImage? { get set }
    
    /// 清除按钮图片的外边距
    var clearButtonIconEdgeInsets: UIEdgeInsets { get set }
    
    /// 清除按钮距离搜索条的边距
    var clearButtonMarginRight: CGFloat { get set }
    
    /// 左侧搜索按钮的图标
    var leftSearchIcon: UIImage? { get set }
    
    /// 左侧搜索按钮图标的外边距
    var leftSearchIconEdgeInsets: UIEdgeInsets { get set }
    
    /// 左侧搜索按钮距离搜索条的外边距
    var leftSearchIconMarginLeft: CGFloat { get set }
    
    /// 下拉列表按钮的字体
    var dropdownButtonFont: UIFont { get set }
    
    /// 下拉列表按钮的文字颜色
    var dropdownButtonTitleColor: UIColor { get set }
    
    /// 下拉列表按钮的收起图标
    var dropdownButtonCollapseIcon: UIImage? { get set }
    
    /// 下拉列表按钮的展开图标
    var dropdownButtonExpandIcon: UIImage? { get set }
    
    /// 下拉列表按钮的图标尺寸
    var dropdownButtonIconSize: CGSize { get set }
    
    /// 下拉列表按钮距离左侧的距离
    var dropdownButtonMarginLeft: CGFloat { get set }
    
    /// 下拉列表的颜色
    var dropdownListBackgroundColor: UIColor { get set }
    
    /// 下拉列表的最小宽度
    var dropdownListMinWidth: CGFloat { get set }
    
    /// 下拉列表距离搜索框底部的距离
    var dropdownListMarginTop: CGFloat { get set }
    
    /// 下拉列表的单元格高度
    var dropdownListCellHeight: CGFloat { get set }
    
    /// 下拉列表的单元格文字颜色
    var dropdownListCellTextColor: UIColor { get set }
    
    /// 下拉列表的单元格选中文字颜色
    var dropdownListCellSelectedTextColor: UIColor { get set }
    
    /// 下拉列表的单元格字体
    var dropdownListCellFont: UIFont { get set }
    
    /// 下拉列表的单元格选中字体
    var dropdownListCellSelectedFont: UIFont { get set }
    
    /// 搜索按钮的文字
    var searchButtonTitle: String { get set }
    
    /// 搜索按钮的字体
    var searchButtonFont: UIFont { get set }
    
    /// 搜索按钮的标题颜色
    var searchButtonTitleColor: UIColor { get set }
    
    /// 搜索按钮的文字的外边距
    var searchButtonContentInsets: UIEdgeInsets { get set }
    
    /// 搜索按钮距离右边的距离
    var searchButtonMarginRight: CGFloat { get set }
    
    /// 搜索按钮的背景颜色
    var searchButtonBackgroundColor: UIColor { get set }
    
    /// 搜索按钮的圆角
    var searchButtonCornerRadius: CGFloat { get set }
    
    /// 联想列表的最大高度
    var associateListMaxHeight: CGFloat { get set }
    
    /// 联想列表的背景颜色
    var associateListBackgoundColor: UIColor { get set }
    
    /// 联想列表的单元格高度
    var associateListCellHeight: CGFloat { get set }
    
    /// 联想列表的单元格字体
    var associateListCellFont: UIFont { get set }
    
    /// 联想列表的单元格字体颜色
    var associateListCellTextColor: UIColor { get set }
    
    /// 联想列表单元格高亮文字颜色
    var associateListCellHighLightTextColor: UIColor { get set }
    
    /// 联想列表的单元格字体距离左侧的距离
    var associateListCellTextMarginLeft: CGFloat { get set }
    
    /// 联想列表的分割线颜色
    var associateListCellSeparatedLineColor: UIColor { get set }
    
    /// 联想列表的分割线距离左侧的位置
    var associateListCellSeparatedLineMarginLeft: CGFloat { get set }
    
    /// 联想列表的分割线高度
    var associateListCellSeparatedLineHeight: CGFloat { get set }
    
    ///
    var keyboardReturnKey: UIReturnKeyType { get set }
}

public class OASearchBarStyle: NSObject, SearchBarStyle {

    /// 需要根据主题更换颜色
    public var barBackgroundColor: UIColor = CHListColors.surface
    
    /// 需要根据主题更换颜色
    public var inputBackgroundColor: UIColor = CHListColors.background
    
    public var inputEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    
    public var inputHintFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    /// 需要根据主题更换颜色
    public var inputHintTextColor: UIColor = CHListColors.onBackground
    
    public var inputFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    /// 需要根据主题更换颜色
    public var inputTextColor: UIColor = CHListColors.onSecondary
    
    public var inputMargingLeft: CGFloat = 0
    
    public var cleartButtonIconSize: CGSize = CGSize(width: 16, height: 16)
    
    public var clearButtonIcon: UIImage? = ListKitAsserts.icon_clear_x16
    
    public var clearButtonIconEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
    
    public var leftSearchIcon: UIImage? = ListKitAsserts.icon_search_x16
    
    public var clearButtonMarginRight: CGFloat = 1
    
    public var leftSearchIconEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    public var leftSearchIconMarginLeft: CGFloat = 4
    
    public var dropdownButtonFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    /// 需要根据主题更换颜色
    public var dropdownButtonTitleColor: UIColor = CHListColors.onSecondary
    
    public var dropdownButtonCollapseIcon: UIImage? = ListKitAsserts.icon_arrow_down_x16
    
    public var dropdownButtonExpandIcon: UIImage? = ListKitAsserts.icon_arrow_up_x16
    
    public var dropdownButtonIconSize: CGSize = CGSize(width: 16, height: 16)
    
    public var dropdownButtonMarginLeft: CGFloat = 4
    
    public var dropdownListBackgroundColor: UIColor = UIColor(rgb: 0x000000, alpha: 0.8)
    
    public var dropdownListMinWidth: CGFloat = 115
    
    /// 下拉列表距离搜索框底部的距离
    public var dropdownListMarginTop: CGFloat = 12
    
    public var dropdownListCellHeight: CGFloat = 42
    
    public var dropdownListCellTextColor: UIColor = UIColor(rgb: 0xffffff, alpha: 0.6)
    
    public var dropdownListCellSelectedTextColor: UIColor = UIColor.white
    
    public var dropdownListCellFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    public var dropdownListCellSelectedFont: UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
    
    public var showSearchButton: Bool = true
    
    public var searchButtonTitle: String = "搜索"
    
    public var searchButtonFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    /// 需要根据主题更换颜色
    public var searchButtonTitleColor: UIColor = CHListColors.onPrimary
    
    public var searchButtonContentInsets: UIEdgeInsets = UIEdgeInsets(top: 3, left: 14, bottom: 3, right: 14)
    
    public var searchButtonMarginRight: CGFloat = 4
    
    ///
    public var searchButtonBackgroundColor: UIColor = CHListColors.primary
    
    public var searchButtonCornerRadius: CGFloat = 12
    
    public var associateListMaxHeight: CGFloat = UIScreen.main.bounds.size.height / 2
    
    public var associateListBackgoundColor: UIColor = CHListColors.surface
    
    public var associateListCellHeight: CGFloat = 44
    
    public var associateListCellFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    /// 需要根据主题更换颜色
    public var associateListCellTextColor: UIColor = CHListColors.onSecondary
    
    /// 需要根据主题更换颜色
    public var associateListCellHighLightTextColor: UIColor = CHListColors.primary
    
    public var associateListCellTextMarginLeft: CGFloat = 24
    
    /// 需要根据主题更换颜色
    public var associateListCellSeparatedLineColor: UIColor = CHListColors.background
    
    public var associateListCellSeparatedLineMarginLeft: CGFloat = 24
    
    public var associateListCellSeparatedLineHeight: CGFloat = 0.5
    
    public var keyboardReturnKey: UIReturnKeyType = UIReturnKeyType.search;
    
}
