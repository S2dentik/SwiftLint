//
//  StyleViolationType.swift
//  SwiftLint
//
//  Created by JP Simard on 2015-05-16.
//  Copyright (c) 2015 Realm. All rights reserved.
//

public enum StyleViolationType: String, CustomStringConvertible {
    case NameFormat                 = "Name Format"
    case Length                     = "Length"
    case TrailingNewline            = "Trailing Newline"
    case LeadingWhitespace          = "Leading Whitespace"
    case TrailingWhitespace         = "Trailing Whitespace"
    case ReturnArrowWhitespace      = "Return Arrow Whitespace"
    case OperatorFunctionWhitespace = "Operator Function Whitespace"
    case ForceCast                  = "Force Cast"
    case TODO                       = "TODO or FIXME"
    case Colon                      = "Colon"
    case Nesting                    = "Nesting"
    case ControlStatement           = "Control Statement Parentheses"
    case ReturnEmptyLines           = "Return Empty Line"
    case Mark                       = "Mark Empty Lines"
    case OperatorWhitespace         = "Operator Whitespace"
    case OpeningBrace               = "Opening Brace"
    case StatementPosition          = "Statement Position"
    case Comma                      = "Comma"
    case ReturnPosition             = "Return Position"
    

    public var description: String { return rawValue }
}
