//
//  main.swift
//  work-async
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
import Work

// Create shell commands.
let echo1 = Work(command: "echo 1-1; sleep 1; echo 1-2; sleep 1; echo 1-3")
echo1.standardOutputHandler = { output in
    print("echo1 says: \(output)")
}
echo1.completion = { result in
    switch result {
    case .success(_):
        print("echo1 success")
    case .failure(_, _):
        print("echo1 failure")
    }
}

let echo2 = Work(
    command: "echo 2-1; sleep 1; echo 2-2; sleep 3; echo 2-3",
    standardOutputHandler: { output in
        print("echo2 says: \(output)")
    }, completion: { result in
        switch result {
        case .success(_):
            print("echo2 success")
        case .failure(_, _):
            print("echo2 failure")
        }
    }
)

// Start them asynchronously.
OperationQueue().addOperations([echo1, echo2], waitUntilFinished: true)
