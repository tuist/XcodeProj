import xcodeproj
import PathKit

let path = Path("/Users/pedropinera/src/github.com/angledotdev/macos/Angle.xcodeproj")
let project = try XcodeProj(path: path)
try project.write(path: path)

print("yolo")
