import SakefileDescription
import SakefileUtils

enum Task: String, CustomStringConvertible {
    case continuousIntegration = "ci"
    case deployToIntegration = "deploy_to_integration"
    var description: String {
        switch self {
        case .continuousIntegration:
            return "Runs all the tasks that need to be run on CI"
        case .deployToIntegration:
            return "Branches out from master to integration and pushes it to remote"
        }
    }
}

Sake<Task> {
    $0.task(.deployToIntegration) { (utils) in
        // Here is where you define your build task
    }
    $0.task(.continuousIntegration) { (utils) in
        // Here is where you define your build task
    }
}.run()
