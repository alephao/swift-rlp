public enum RLPValue: Equatable, Sendable {
    case string(String)
    case array([RLPValue])
}
