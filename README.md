<div align="center"><img src="/Assets/logo.svg" width="250" /></div>
<h1 align="center">
  <b>Work</b>
  <br>
  <a href="https://github.com/flintbox/Work/releases"><img src="https://img.shields.io/github/release/flintbox/Work.svg" alt="GitHub release" /></a>
  <a href="https://swift.org/package-manager"><img src="https://img.shields.io/badge/Swift%20PM-compatible-orange.svg" alt="Swift Package Manager" /></a>
  <a href="https://github.com/flintbox/Work/blob/master/LICENSE"><img src="https://img.shields.io/github/license/mashape/apistatus.svg" alt="license" /></a>
</h1>

*Execute shell command and get output. **Simple** and **robust**.*

**Table of Contents**
- [Installation](#installation)
- [Work](#work)
- [Example](#example)
  - [Synchronous](#synchronous)
  - [Asynchronous](#asynchronous)
- [Contribute](#contribute)

## Installation

Add Work to `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/flintbox/Work", from: "0.1.0")
]
```

## Work

[Work](https://github.com/flintbox/Work/blob/master/Sources/Work/Work.swift) is subclass of [Operation](https://developer.apple.com/documentation/foundation/operation) wrapping [Process](https://developer.apple.com/documentation/foundation/process) object.

## Example

### Synchronous

#### [main.swift](https://github.com/flintbox/Work/blob/master/Sources/work-sync/main.swift)

```swift
import Foundation
import Work

// Create shell commands.
let echo1 = Work(
    command: "echo 1-1; sleep 1; echo 1-2; sleep 1; echo 1-3",
    standardOutputHandler: { output in
        print("echo1 says: \(output)")
    }
)
let echo2 = Work(command: "echo 2-1; sleep 1; echo 2-2; sleep 1; echo 2-3")

// Start them synchronously.
echo1.start()
echo2.start()

// Print standard output of echo2.
print(echo2.standardOutput)
```

#### Output

```shell
echo1 says: 1-1
echo1 says: 1-2
echo1 says: 1-3
2-1
2-2
2-3
```

### Asynchronous

#### [main.swift](https://github.com/flintbox/Work/blob/master/Sources/work-async/main.swift)

```swift
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
```

#### Output

```shell
echo2 says: 2-1
echo1 says: 1-1
echo2 says: 2-2
echo1 says: 1-2
echo1 says: 1-3
echo1 success
echo2 says: 2-3
echo2 success
```

## Contribute

If you have good idea or suggestion? Please, don't hesitate to open a pull request or send me an [email](mailto:contact@jasonnam.com).

Hope you enjoy building command line tool with Work!
