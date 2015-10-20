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

public struct ReturnStatementRule: Rule {
    public init() { }
    public let identifier = "return_statement"
    public func validateFile(file: File) -> [StyleViolation] {
        return validateFile(file, dictionary: file.structure.dictionary)
    }
    
    public func validateFile(file: File, dictionary: XPCDictionary) -> [StyleViolation] {
        let substructure = dictionary["key.substructure"] as? XPCArray ?? []
        return substructure.flatMap { subItem -> [StyleViolation] in
            var violations = [StyleViolation]()
            if let subDict = subItem as? XPCDictionary,
                let kindString = subDict["key.kind"] as? String,
                let kind = SwiftDeclarationKind(rawValue: kindString) {
                    violations.appendContentsOf(
                        self.validateFile(file, dictionary: subDict) +
                            self.validateFile(file, kind: kind, dictionary: subDict)
                    )
            }
            return violations
        }
    }
    
    
    public func validateFile(file: File,
        kind: SwiftDeclarationKind,
        dictionary: XPCDictionary) -> [StyleViolation] {
            let functionKinds: [SwiftDeclarationKind] = [
                .FunctionAccessorAddress,
                .FunctionAccessorDidset,
                .FunctionAccessorGetter,
                .FunctionAccessorMutableaddress,
                .FunctionAccessorSetter,
                .FunctionAccessorWillset,
                .FunctionConstructor,
                .FunctionDestructor,
                .FunctionFree,
                .FunctionMethodClass,
                .FunctionMethodInstance,
                .FunctionMethodStatic,
                .FunctionOperator,
                .FunctionSubscript
            ]
            if !functionKinds.contains(kind) {
                return []
            }
            
            return []
            
    }
    public let example = RuleExample(
        ruleName: "Return Rule",
        ruleDescription: "This rule checks whether you have put empty lines " +
            "before and after return statement correctly.",
        nonTriggeringExamples: [
            "func abc() {\nreturn}",
            "func abc() -> Int {\nlet a = 1\n\n\treturn a}",
            "func abc() -> Int {\nlet a = 1\n  \t\n\treturn a}"
        ],
        triggeringExamples: [
            "func abc() {\n\nreturn}",
            "func abc() -> Int {\nlet a = 1\n\treturn a}",
            "func abc() -> Int {\nlet a = 1\n    return a}"
        ]
    )
}