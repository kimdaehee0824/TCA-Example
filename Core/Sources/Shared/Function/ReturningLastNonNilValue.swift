import ComposableArchitecture

public func returningLastNonNilValue<A, B>(_ f: @escaping (A) -> B?) -> (A) -> B? {
    var lastWrapped: B?
    return { wrapped in
        lastWrapped = f(wrapped) ?? lastWrapped
        return lastWrapped
    }
}
