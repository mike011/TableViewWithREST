// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let project = try? newJSONDecoder().decode(Project.self, from: jsonData)

import Foundation

// MARK: - Project
struct Project: Codable {
    let compare: JSONNull?
    let previousSuccessfulBuild: Previous?
    let buildParameters: BuildParameters
    let oss, allCommitDetailsTruncated: Bool?
    let committerDate: String?
    let steps: [Step]?
    let body, usageQueuedAt: String?
    let contextIDS: [JSONAny]?
    let failReason, retryOf: JSONNull?
    let reponame: String?
    let sshUsers: [JSONAny]?
    let buildURL: String?
    let parallel: Int?
    let failed: Bool?
    let branch, username: String?
    let authorDate: String?
    let why: String?
    let user: User?
    let vcsRevision: String?
    let workflows: Workflows?
    let owners: [String]?
    let vcsTag: JSONNull?
    let pullRequests: [PullRequest]?
    let buildNum: Int?
    let infrastructureFail: Bool?
    let committerEmail: String?
    let hasArtifacts: Bool?
    let previous: Previous?
    let status, committerName: String?
    let retries: JSONNull?
    let subject, vcsType: String?
    let timedout: Bool?
    let dontBuild: String?
    let lifecycle: String?
    let noDependencyCache: Bool?
    let stopTime: String?
    let sshDisabled: Bool?
    let buildTimeMillis: Int?
    let picard: Picard?
    let circleYml: CircleYml?
    let messages: [JSONAny]?
    let isFirstGreenBuild: Bool?
    let jobName: JSONNull?
    let startTime: String?
    let canceler: JSONNull?
    let allCommitDetails: [AllCommitDetail]?
    let platform, outcome: String?
    let vcsURL: String?
    let authorName: String?
    let node: JSONNull?
    let queuedAt: String?
    let canceled: Bool?
    let authorEmail: String?

    enum CodingKeys: String, CodingKey {
        case compare
        case previousSuccessfulBuild = "previous_successful_build"
        case buildParameters = "build_parameters"
        case oss
        case allCommitDetailsTruncated = "all_commit_details_truncated"
        case committerDate = "committer_date"
        case steps, body
        case usageQueuedAt = "usage_queued_at"
        case contextIDS = "context_ids"
        case failReason = "fail_reason"
        case retryOf = "retry_of"
        case reponame
        case sshUsers = "ssh_users"
        case buildURL = "build_url"
        case parallel, failed, branch, username
        case authorDate = "author_date"
        case why, user
        case vcsRevision = "vcs_revision"
        case workflows, owners
        case vcsTag = "vcs_tag"
        case pullRequests = "pull_requests"
        case buildNum = "build_num"
        case infrastructureFail = "infrastructure_fail"
        case committerEmail = "committer_email"
        case hasArtifacts = "has_artifacts"
        case previous, status
        case committerName = "committer_name"
        case retries, subject
        case vcsType = "vcs_type"
        case timedout
        case dontBuild = "dont_build"
        case lifecycle
        case noDependencyCache = "no_dependency_cache"
        case stopTime = "stop_time"
        case sshDisabled = "ssh_disabled"
        case buildTimeMillis = "build_time_millis"
        case picard
        case circleYml = "circle_yml"
        case messages
        case isFirstGreenBuild = "is_first_green_build"
        case jobName = "job_name"
        case startTime = "start_time"
        case canceler
        case allCommitDetails = "all_commit_details"
        case platform, outcome
        case vcsURL = "vcs_url"
        case authorName = "author_name"
        case node
        case queuedAt = "queued_at"
        case canceled
        case authorEmail = "author_email"
    }
}

// MARK: - AllCommitDetail
struct AllCommitDetail: Codable {
    let committerDate: String?
    let body, branch: String?
    let authorDate: String?
    let committerEmail, commit, committerLogin, committerName: String?
    let subject: String?
    let commitURL: String?
    let authorLogin, authorName, authorEmail: String?

    enum CodingKeys: String, CodingKey {
        case committerDate = "committer_date"
        case body, branch
        case authorDate = "author_date"
        case committerEmail = "committer_email"
        case commit
        case committerLogin = "committer_login"
        case committerName = "committer_name"
        case subject
        case commitURL = "commit_url"
        case authorLogin = "author_login"
        case authorName = "author_name"
        case authorEmail = "author_email"
    }
}

// MARK: - BuildParameters
struct BuildParameters: Codable {
    let circleJob: String

    enum CodingKeys: String, CodingKey {
        case circleJob = "CIRCLE_JOB"
    }
}

// MARK: - CircleYml
struct CircleYml: Codable {
    let string: String?
}

// MARK: - Picard
struct Picard: Codable {
    let buildAgent: BuildAgent?
    let resourceClass: ResourceClass?
    let executor: String?

    enum CodingKeys: String, CodingKey {
        case buildAgent = "build_agent"
        case resourceClass = "resource_class"
        case executor
    }
}

// MARK: - BuildAgent
struct BuildAgent: Codable {
    let image: String?
    let properties: Properties?
}

// MARK: - Properties
struct Properties: Codable {
    let buildAgent, executor: String?

    enum CodingKeys: String, CodingKey {
        case buildAgent = "build_agent"
        case executor
    }
}

// MARK: - ResourceClass
struct ResourceClass: Codable {
    let cpu, ram: Int?
    let resourceClassClass: String?

    enum CodingKeys: String, CodingKey {
        case cpu, ram
        case resourceClassClass = "class"
    }
}

// MARK: - Previous
struct Previous: Codable {
    let buildNum: Int?
    let status: String?
    let buildTimeMillis: Int?

    enum CodingKeys: String, CodingKey {
        case buildNum = "build_num"
        case status
        case buildTimeMillis = "build_time_millis"
    }
}

// MARK: - PullRequest
struct PullRequest: Codable {
    let headSHA: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case headSHA = "head_sha"
        case url
    }
}

// MARK: - Step
struct Step: Codable {
    let name: String?
    let actions: [Action]?
}

// MARK: - Action
struct Action: Codable {
    let truncated: Bool?
    let index: Int?
    let parallel: Bool?
    let failed, infrastructureFail: JSONNull?
    let name: String?
    let bashCommand: String?
    let status: String?
    let timedout, actionContinue: JSONNull?
    let endTime, type, allocationID: String?
    let outputURL: String?
    let startTime: String
    let background: Bool?
    let exitCode: Int?
    let insignificant: Bool?
    let canceled: JSONNull?
    let step, runTimeMillis: Int?
    let hasOutput: Bool?

    enum CodingKeys: String, CodingKey {
        case truncated, index, parallel, failed
        case infrastructureFail = "infrastructure_fail"
        case name
        case bashCommand = "bash_command"
        case status, timedout
        case actionContinue = "continue"
        case endTime = "end_time"
        case type
        case allocationID = "allocation_id"
        case outputURL = "output_url"
        case startTime = "start_time"
        case background
        case exitCode = "exit_code"
        case insignificant, canceled, step
        case runTimeMillis = "run_time_millis"
        case hasOutput = "has_output"
    }
}

// MARK: - User
struct User: Codable {
    let isUser: Bool?
    let login: String?
    let avatarURL: String?
    let name, vcsType: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case isUser = "is_user"
        case login
        case avatarURL = "avatar_url"
        case name
        case vcsType = "vcs_type"
        case id
    }
}

// MARK: - Workflows
struct Workflows: Codable {
    let jobName, jobID, workflowID, workspaceID: String?
    let upstreamJobIDS: [String]?
    let upstreamConcurrencyMap: [String: [String]]?
    let workflowName: String?

    enum CodingKeys: String, CodingKey {
        case jobName = "job_name"
        case jobID = "job_id"
        case workflowID = "workflow_id"
        case workspaceID = "workspace_id"
        case upstreamJobIDS = "upstream_job_ids"
        case upstreamConcurrencyMap = "upstream_concurrency_map"
        case workflowName = "workflow_name"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONNullBool: Decodable, Hashable {

    private var value: Bool

    public static func == (lhs: JSONNullBool, rhs: JSONNullBool) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {
        value = false
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = false
        if !container.decodeNil() {
            if let value = try? container.decode(Bool.self) {
                self.value = value
            } else {
                throw DecodingError.typeMismatch(JSONNullBool.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNullBool"))
            }
        }
    }

}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
