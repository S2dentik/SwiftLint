//
//  OperatorWhitespaceRule.swift
//  SwiftLint
//
//  Created by Alex Culeva on 10/20/15.
//  Copyright © 2015 Realm. All rights reserved.
//

import Foundation
import SourceKittenFramework
import SwiftXPC

//TODO: Change regex
public struct OperatorWhitespaceRule: Rule {
    public init() { }
    public let identifier = "operator_whitespace"
    
    public func validateFile(file: File) -> [StyleViolation] {
        let nonValidNeighbour = "(?:[^ ]|  |\\t)?"
        let singleOperators = "[\\!\\+\\/\\-\\*\\%\\<\\>]"
        let doubleOperators = "=|==|<=|>=|\\|\\||\\&\\&|!="
        let pattern = "\(nonValidNeighbour)(\(singleOperators)(?!=)|" +
            "\(doubleOperators))(?! )" + "|" +
            "(?<! )(\(singleOperators)(?!=)|(?<![!\\/\\%-\\+\\*])" +
            "\(doubleOperators))\(nonValidNeighbour)"
        
        let checkKinds: [SwiftKind] = [
            .If,
            .While,
            .For,
            .Switch,
            .VarClass,
            .VarInstance,
            .VarGlobal,
            .VarStatic,
            .VarLocal,
            .VarParameter
        ]
        
        return validateFile(file,
            dictionaries: filterDictionary(file, dictionary: file.structure.dictionary, validKinds: checkKinds),
            violations: file.matchPattern(pattern).map { match, syntaxKind in
                return StyleViolation(type: StyleViolationType.OperatorWhitespace,
                    location: Location(file: file, offset: match.location),
                    severity: .Warning,
                    reason: "There should be a space before and after binary operators")
        })
    }
    
    public func filterDictionary(file: File, dictionary: XPCDictionary, validKinds: [SwiftKind]) -> [XPCDictionary] {
        let substructure = dictionary["key.substructure"] as? XPCArray ?? []
        var validComponents = [XPCDictionary]()
        return substructure.flatMap { subItem -> [XPCDictionary] in
            if let subDict = subItem as? XPCDictionary {
                if let substr = subDict["key.substructure"] as? XPCDictionary {
                    let childComponents = self.filterDictionary(file, dictionary: substr, validKinds: validKinds)
                    validComponents.appendContentsOf(childComponents)
                }
                validComponents.append(subDict)
            }
            return validComponents
            }.filter {
            if let kindString = $0["key.kind"] as? String,
                let kind = SwiftKind(rawValue: kindString) {
                    return validKinds.contains(kind)
                }
            return false
        }
    }


    public func validateFile(file: File, dictionaries: [XPCDictionary],
        violations: [StyleViolation]) -> [StyleViolation] {
            return violations.filter {
                for dictionary in dictionaries {
                    if let offset = (dictionary["key.offset"] as? Int64).flatMap({ Int($0) }),
                        let length = (dictionary["key.length"] as? Int64).flatMap({ Int($0) }) {
                            let bodyLength = (dictionary["key.bodylength"] as? Int64).flatMap({ Int($0) }) ?? 0
                            let startLocation = Location(file: file, offset: offset)
                            let endLocation = Location(file: file, offset: offset + length + bodyLength - 1)
                                
                            return $0.location < endLocation && startLocation < $0.location
                    }
                }
                return false
            }
    }
    
    public let example = RuleExample(
        ruleName: "Operator Whitespace rule",
        ruleDescription: "Every binary operator should have one space before " +
        "and after itself",
        nonTriggeringExamples: [
            "let a = 1 + 2 - 3 % 4 / 5 * 6",
            "let a = true && false || true",
            "let a = 1 != 2",
            "a /= 1",
            "if 2 + 3 < 2 { }",
            "//MARK:",
            "func abc<>() { }"
        ],
        triggeringExamples: [
            "let a= 1 + 2 / 3",
            "let a =1 - 5 % 6",
            "let a = 1* 2",
            "let a = true&& false || true",
            "let a = 1< 3 && 4 > 5",
            "a/= 1",
            "if 2+ 3 < 2 { }"
        ],
        showExamples: false
    )
}
