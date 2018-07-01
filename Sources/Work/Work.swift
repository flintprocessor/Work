//
//  Work.swift
//  Work
//
//  Copyright (c) 2018 Jason Nam (https://jasonnam.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// Shell command.
open class Work: Operation {

    /// Termination result.
    open private(set) var result: WorkResult?

    // Standard output.
    open var standardOutput: String {
        return standardOutputRawString.trimmingNewLineCharacter()
    }
    // Standard error.
    open var standardError: String {
        return standardErrorRawString.trimmingNewLineCharacter()
    }

    /// Standard output raw string.
    private var standardOutputRawString: String
    /// Standard error raw string.
    private var standardErrorRawString: String

    /// Standard output pipe.
    public let standardOutputPipe: Pipe
    /// Standard error pipe.
    public let standardErrorPipe: Pipe

    /// Process object.
    public let task: Process
    /// Standard output handler.
    open var standardOutputHandler: ((String) -> Void)?
    /// Standard error handler.
    open var standardErrorHandler: ((String) -> Void)?
    /// Block invoked on process termination.
    open var completion: ((WorkResult) -> Void)?

    /// Initialize work.
    ///
    /// - Parameters:
    ///   - command: Shell command to execute.
    ///   - standardOutputHandler: Standard output handler.
    ///   - standardErrorHandler: Standard error handler.
    ///   - completion: Block invoked on process termination.
    public init(command: String,
                standardOutputHandler: ((String) -> Void)? = nil,
                standardErrorHandler: ((String) -> Void)? = nil,
                completion: ((WorkResult) -> Void)? = nil) {
        task = Process()
        self.standardOutputHandler = standardOutputHandler
        self.standardErrorHandler = standardErrorHandler
        self.completion = completion

        standardOutputPipe = Pipe()
        standardErrorPipe = Pipe()

        standardOutputRawString = ""
        standardErrorRawString = ""

        super.init()

        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        task.standardOutput = standardOutputPipe
        task.standardError = standardErrorPipe

        standardOutputPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            guard let string = String(data: fileHandle.availableData, encoding: .utf8) else { return }
            guard !string.isEmpty else { return }
            self?.standardOutputRawString += string
            self?.standardOutputHandler?(string.trimmingNewLineCharacter())
        }
        standardErrorPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            guard let string = String(data: fileHandle.availableData, encoding: .utf8) else { return }
            guard !string.isEmpty else { return }
            self?.standardErrorRawString += string
            self?.standardErrorHandler?(string.trimmingNewLineCharacter())
        }
    }

    /// Execute shell command.
    open override func main() {
        task.launch()
        task.waitUntilExit()
        if task.terminationStatus == EXIT_SUCCESS {
            result = .success(self)
        } else {
            result = .failure(self, task.terminationStatus)
        }
        completion?(result!)
    }
}
