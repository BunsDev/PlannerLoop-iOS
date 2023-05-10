//
//  APIModel.swift
//  PlannerLoop
//  Structures for communication with API 
//  Created by Tomáš Tomala
//

import Foundation

/// Structure holding user info
struct Credentials: Codable {
    var email: String = ""
    var password: String = ""
}

/// Main output structure of PlannerLoop API response
struct APIResponse: Codable {
    var dbrecord: DBUser?
    var dbselect: String?
    var dbtasks: [DBTask]?
}

/// Output structure of PlannerLoop API Error response
struct HGError: Codable {
    var ErrorCode: Int
    var ErrorText: String
}

/// Output structure from API holding information about tasks
struct DBTask: Codable {
    var ID: Int
    var UserID: String
    var TaskID: String
    var TaskClass: String
    var Priority: Int
    var Status: Int
    var TokenPrice: Int
}

/// Output structure  API holding information about user
struct DBUser: Codable {
    var userID: String
    var password: String
    var appKey: String
    var email: String
    var vip: Int
    var status: Int
    var tokens: Int
}

/// Input and output API structure holding information about task to submit
struct HGSubmitBody: Codable {
    var AttachmentEncoded: String
    var TaskClass: String
    var OrigFileName: String
    var SourceOfOrigin: String
}

/// Output structure of API holding information about status of a task
struct HGTaskStatus: Codable  {
    let TaskID: String
    let UserID: String
    let TaskClass: String
    let Status: Int
    let Tokens: Int
    let FileEncoded: String
    let Origin: Origin?
    let CompResult: CompResult?
    let DBEvents: [DBEvent]?
}

/// Output structure of API holding information with computed task
struct Origin: Codable  {
    let AttachmentEncoded: String
    let TaskClass: String
    let OrigFileName: String
    let SourceOfOrigin: String
}

/// Output structure of API holding information scheduling computation result
struct CompResult: Codable  {
    let WExitCode: Int
    let OptExitCode: Int
}

/// Output structure of API holding information scheduling computation result
struct DBEvent: Codable {
    var id: String
}

/// Enumeration of values describing user status
enum UserStatus: Int {
    case regular = 1
    case admin = 16
    case suspended = 99
}

/// Enumeration of values describing task status
enum TaskStatus: Int {
    case received = 1
    case workerAssigned = 2
    case scheduling = 3
    case scheduled = 4
    case canceled = 5
    case failed = 6
    case closed = 7
}

/// Enumeration of values describing task status
struct ToastInfo {
    var text: String = ""
    var show: Bool = false
}

/// Enumeration of values describing API Error
enum APIError: Int {
    case HTTPGNoError = 0
    case HTTPGErrorNoAuth = 1
    case HTTPGErrorUserNotValid = 20
    case HTTPGErrorSubmissionBodyFormat = 21
    case HTTPGErrorVolumeFileError = 22
    case HTTPGErrorSubmissionAttachment = 23
    case HTTPGErrorUserLowTokens = 24
    case HTTPGErrorSubmissionAttrs = 25
    case HTTPGErrorTaskID = 30
    case HTTPGErrorTaskIDUserNotOwner = 31
    case HTTPGErrorTaskIDCannotChangeStatus = 32
    case HTTPGErrorTaskIDNotExisting = 33
    case HTTPGErrorTaskStatusChangeNotAllowed = 34
    case HTTPGErrorUserAlreadyRegistered = 40
    case HTTPGErrorUserUpdateStatusNotPerm = 41
    case HTTPGErrorUserNotAllowed = 42
    case HTTPGErrorServerTimeout = 100
    case HTTPGErrorDBError = 101
    case HTTPGErrorNotImplemented = 102
    case HTTPGErrorTechTrouble = 103
    case HTTPGErrorNoConnection = 104
    
    func bindToDescrptn() -> ErrorDescription {
        switch self {
        case .HTTPGNoError:
            return .noError
        case .HTTPGErrorNoAuth:
            return .invalidUserData
        case .HTTPGErrorUserNotValid:
            return .invalidUserData
        case .HTTPGErrorSubmissionAttachment:
            return .invalidDBFile
        case .HTTPGErrorSubmissionBodyFormat:
            return .invalidDBFile
        case .HTTPGErrorUserLowTokens:
            return .noCredits
        case .HTTPGErrorSubmissionAttrs:
            return .invalidServerResponse
        case .HTTPGErrorTaskID:
            return .noOperationInfo
        case .HTTPGErrorTaskIDUserNotOwner:
            return .noOperationInfo
        case .HTTPGErrorTaskIDNotExisting:
            return .noOperationInfo
        case .HTTPGErrorTaskIDCannotChangeStatus:
            return .invalidServerResponse
        case .HTTPGErrorTaskStatusChangeNotAllowed:
            return .invalidServerResponse
        case .HTTPGErrorUserAlreadyRegistered:
            return .alreadyRegistered
        case .HTTPGErrorServerTimeout:
            return .noConnection
        case .HTTPGErrorNoConnection:
            return .noConnection
        default:
            return .unknown
        }
    }
}
