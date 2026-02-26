extension Collection where Element: BinaryInteger, Index == Int {
    @inlinable
    @inline(__always)
    func containsCString<T: BidirectionalCollection>(_ cString: T) -> Bool where T.Element: BinaryInteger, T.Index == Int {
        guard !cString.isEmpty else { return true }

        // Drop null terminator if present
        let subarrayCount = cString.last == 0
            ? cString.count - 1
            : cString.count

        guard subarrayCount <= count else { return false }

        let lastSubarrayStartingPos = count - subarrayCount
        var i = 0
        while i <= lastSubarrayStartingPos {
            var match = true
            var j = 0
            while j < subarrayCount {
                if self[i + j] != cString[j] {
                    match = false
                    break
                }
                j += 1
            }
            if match {
                return true
            }

            i += 1
        }
        return false
    }
}
