import Foundation
import os.log

public struct Logger {
    private let subsystem = "com.wallbaduk.app"
    private let osLog: OSLog
    
    public init(category: String) {
        self.osLog = OSLog(subsystem: subsystem, category: category)
    }
    
    public func debug(_ message: String) {
        os_log("%@", log: osLog, type: .debug, message)
    }
    
    public func info(_ message: String) {
        os_log("%@", log: osLog, type: .info, message)
    }
    
    public func error(_ message: String) {
        os_log("%@", log: osLog, type: .error, message)
    }
    
    public func fault(_ message: String) {
        os_log("%@", log: osLog, type: .fault, message)
    }
} 