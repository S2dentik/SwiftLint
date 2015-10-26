//
//  File.swift
//  SwiftLint
//
//  Created by Alex Culeva on 10/20/15.
//  Copyright © 2015 Realm. All rights reserved.
//

import Foundation
import SourceKittenFramework
import SwiftXPC

public struct ReturnPositionRule: Rule {
    public init() { }
    public let identifier = "return_position"
    
    public func validateFile(file: File) -> [StyleViolation] {
        let wrongCharactersInName = "[^a-z0-9A-Z\\_\\$]"
        let spaceAfterBrace = "\\{ "
        let nextLineAfterBrace = "[\\{\\:][^\\n\\}]*\\n[\\t ]*"
        let oneEmptyLineIfNotBrace = "[^\\s{:][\\t ]*\\n[\\t ]*\\n[\\t ]*"
        let returnPattern = "(return)"
        let pattern = "(?:" + spaceAfterBrace + "|" + nextLineAfterBrace + "|" +
            oneEmptyLineIfNotBrace + ")" + returnPattern + wrongCharactersInName
        let excludingKinds = [SyntaxKind.Comment, .CommentMark, .CommentURL, .DocComment, .DocCommentField, .String]
        //Non-capturing group not working somehow so correct the range
        let correctReturns = file.matchPattern(pattern, excludingSyntaxKinds: excludingKinds).map {
            NSRange(location: $0.location + $0.length - 7, length: 6)
        }
        let allReturns = file.matchPattern(returnPattern, excludingSyntaxKinds: excludingKinds)
        return allReturns.filter { !correctReturns.contains($0) }.map { match in
                return StyleViolation(type: .ReturnPosition,
                    location: Location(file: file, offset: match.location),
                    severity: .Warning,
                    reason: "Return statement must be placed correctly")
        }
    }
    
    public let example = RuleExample(
        ruleName: "Return Rule",
        ruleDescription: "This rule checks whether you have put empty lines " +
            "before and after return statement correctly.",
        nonTriggeringExamples: [
            "func abc() {\nreturn}",
            "func abc() -> Int {\nlet a = 1\n\n\treturn a}",
            "func abc() -> Int {\nlet a = 1\n  \t\n\treturn a}",
            "switch 1 {\ncase 1:\n return true\ndefault:\n break }"
        ],
        triggeringExamples: [
            "func abc() {\n\nreturn}",
            "func abc() -> Int {\nlet a = 1\n\treturn a}",
            "func abc() -> Int {\nlet a = 1\n    return a}"
        ]
    )
}

extension NSRange: Equatable { }
public func == (lhs: NSRange, rhs: NSRange) -> Bool {
    return lhs.length == rhs.length &&
        lhs.location == rhs.location
}