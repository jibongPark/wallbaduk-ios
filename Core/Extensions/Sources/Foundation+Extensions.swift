import Foundation

// MARK: - Array Extensions
public extension Array {
    /// 안전한 인덱스 접근
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - String Extensions
public extension String {
    /// 빈 문자열이 아닌지 확인
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// 공백 제거 후 빈 문자열인지 확인
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Optional Extensions
public extension Optional {
    /// nil이 아닌지 확인
    var isNotNil: Bool {
        return self != nil
    }
}

// MARK: - Int Extensions
public extension Int {
    /// 범위 내 값인지 확인
    func isInRange(_ range: ClosedRange<Int>) -> Bool {
        return range.contains(self)
    }
} 