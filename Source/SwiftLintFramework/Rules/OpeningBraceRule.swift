//
//  OpeningBraceRule.swift
//  SwiftLint
//
//  Created by Alex Culeva on 10/21/15.
//  Copyright © 2015 Realm. All rights reserved.
//

import Foundation
import SourceKittenFramework

public struct OpeningBraceRule: Rule {
    public init() { }
    
    public let identifier = "opening_brace"
    
    public func validateFile(file: File) -> [StyleViolation] {
        let pattern = "((?:[^( ]|[\\s(] ){)"
        
        return file.matchPattern(pattern).map { match, syntaxKinds in
            return StyleViolation(type: StyleViolationType.Mark,
                location: Location(file: file, offset: match.location),
                severity: .Warning,
                reason: "One space before opening brace and on the same line " +
                    "as declaration")
        }
    }
    
    public let example = RuleExample(
        ruleName: "Opening Brace Spacing Rule",
        ruleDescription: "Check whether there is a space before opening " +
        "brace and it is on the same line.",
        nonTriggeringExamples: [
            "func abc() {\n}",
            "[].map() { $0 }",
            "[].map({ })"
        ],
        triggeringExamples: [
            "func abc(){\n}",
            "func abc()\n\t{ }",
            "[].map(){ $0 }",
            "[].map( { } )"
        ],
        showExamples: false
    )
}