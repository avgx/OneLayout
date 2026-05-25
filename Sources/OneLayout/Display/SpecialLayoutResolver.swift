import Foundation

/// Built-in special layout kind (`special_layouts` key).
public enum SpecialLayoutKind: String, Sendable, Equatable {
    case favorite
    case alarm
    case dynamic
}

extension ListLayoutsResponse {
    /// Resolves a special layout item when enabled in `special_layouts`.
    public func layout(for kind: SpecialLayoutKind) -> LayoutFull? {
        guard let reference = specialLayoutReference(for: kind) else { return nil }
        guard reference.enabled || kind == .dynamic else { return nil }
        guard !reference.id.isEmpty else { return nil }

        if let match = items?.first(where: { matches($0, reference: reference, kind: kind) }) {
            return match
        }

        return nil
    }

    /// Alarm layout from `special_layouts.alarm` or any item marked `is_for_alarm`.
    public func alarmLayout() -> LayoutFull? {
        if let special = layout(for: .alarm) {
            return special
        }

        return items?.first { item in
            item.body?.isForAlarm == true || item.body?.alarmMode == true
        }
    }

    private func specialLayoutReference(for kind: SpecialLayoutKind) -> SpecialLayoutReference? {
        guard let specialLayouts else { return nil }
        switch kind {
        case .favorite: return specialLayouts.favorite
        case .alarm: return specialLayouts.alarm
        case .dynamic: return specialLayouts.dynamic
        }
    }

    private func matches(
        _ item: LayoutFull,
        reference: SpecialLayoutReference,
        kind: SpecialLayoutKind
    ) -> Bool {
        guard let body = item.body else { return false }
        if body.id == reference.id { return true }
        if body.id == kind.rawValue { return true }
        if let meta = item.meta, meta.layoutId == reference.id { return true }
        return false
    }
}
