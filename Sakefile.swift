import SakefileDescription
import SakefileUtils

enum Task: String, CustomStringConvertible {
    case build
    var description: String {
        switch self {
            case .build:
                return "Builds the project"
        }
    }
}

Sake<Task> {
    $0.task(.build) { (utils) in
        // Here is where you define your build task
    }
}.run()