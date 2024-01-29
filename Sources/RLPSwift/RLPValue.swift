public enum RLPValue: Equatable {
    case string(String)
    case array([RLPValue])
}
