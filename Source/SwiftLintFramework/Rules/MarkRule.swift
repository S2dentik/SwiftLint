//
//  File.swift
//  SwiftLint
//
//  Created by Alex Culeva on 10/20/15.
//  Copyright © 2015 Realm. All rights reserved.
//

import Foundation
import SourceKittenFramework

public struct MarkRule: Rule {
    public init() { }

    public let identifier = "mark"

    public func validateFile(file: File) -> [StyleViolation] {
        let markRegex = "\\/\\/MARK:"

        // ex: \n\n\n//MARK:
        let pattern1 = file.matchPattern("(\n[\t ]*\n[\t ]*\n[\t ]*)\(markRegex)")

        // ex: //MARK:\n\n\n
        let pattern2 = file.matchPattern("(\(markRegex)[^\n]*\n[\t ]*\n[\t ]*\n)")

        // ex: let a = 1 \n//MARK:
        let pattern3 = file.matchPattern("([^ \t\n][ \t]*\n[\t ]*\(markRegex))")

        // ex: //MARK: \n let a = 1
        let pattern4 = file.matchPattern("(\(markRegex)[^\n]*\n[^ \t\n])")


        return (pattern1 + pattern2 + pattern3 + pattern4).map { match, syntaxKinds in
            return StyleViolation(type: StyleViolationType.Mark,
                location: Location(file: file, offset: match.location),
                severity: .Warning,
                reason: "File should have 1 empty line before and after //MARK:")
        }
    }

    public let example = RuleExample(
        ruleName: "Mark Spacing Rule",
        ruleDescription: "Check whether there is by one empty line before " +
            "and after //MARK:",
        nonTriggeringExamples: [
            "let a = 1\n\n\t //MARK: Another var\n\n let b = 2"
        ],
        triggeringExamples: [
            "let a = 1\n\t //MARK: Another var\n let b = 2",
            "let a = 1\n\n\n\t //MARK: Another var\n\n let b = 2"
        ],
        showExamples: false
    )
}
