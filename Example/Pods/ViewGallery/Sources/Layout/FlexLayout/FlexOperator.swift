//
//  FlexOperator.swift
//  
//
//  Created by Nan Yang on 2022/7/22.
//

postfix operator %

/// 90.0%
public postfix func % (value: Double) -> StyleValue {
    return .percentage(value)
}

/// 90%
public postfix func % (value: Int) -> StyleValue {
    return .percentage(Double(value))
}
