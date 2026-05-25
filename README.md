# OneLayout

Swift package for Native BL **layout** types (`LayoutManager.proto`), `GET /v1/layouts`, and pure display helpers for three layout modes.

**Platforms:** iOS 15+, macOS 13+, tvOS 17+, visionOS 1+  
**Swift tools:** 6.1+

## Dependencies

| Package | Role |
|---------|------|
| [RequestResponse](https://github.com/avgx/RequestResponse) | `LayoutApi.list()` → `Request<ListLayoutsResponse>` |
| [OneWireFormat](https://github.com/avgx/OneWireFormat) | `AccessPoint` on layout cells |
| [SafeEnum](https://github.com/avgx/SafeEnum) | `MapViewMode` and other open-ended enums |

## API

| API | Method | HTTP | Response |
|-----|--------|------|----------|
| `LayoutApi.list(view:)` | GET | `v1/layouts?view=VIEW_MODE_FULL` | `ListLayoutsResponse` |

Proto: [`LayoutManager.proto`](https://github.com/jerrygergov/axxon-telegram-vms/blob/main/support/protos/axxonsoft/bl/layout/LayoutManager.proto)

## Display modes

OneLayout provides **pure logic** (no SwiftUI). The app chooses a mode:

### Mode 1 — Grid / AdaptiveGrid

Ignore cell geometry; show cameras in a uniform grid sorted by cell position.

```swift
import OneLayout

let response: ListLayoutsResponse = ...
let layout = response.items?.first?.body!
let cameras = layout.cameraAccessPoints() // [AccessPoint] without hosts/ prefix
// LazyVGrid or AdaptiveGrid over cameras
```

### Mode 2 — Proportional mosaic

Use normalized frames (0…1 from each edge). **Force landscape in the UI layer** when using this mode.

```swift
let frames = LayoutCellGeometrySolver.frames(for: layout)
for frame in frames {
    // frame.left, frame.top, frame.right, frame.bottom
    // frame.cameraAccessPoint
}
```

Port of webclient `solvePositions` (`layout.ts`).

### Mode 3 — Special layouts

Resolve favorite, alarm, or dynamic layouts from `special_layouts` metadata.

```swift
if let alarm = response.alarmLayout() {
    let body = alarm.body
}
let favorite = response.layout(for: .favorite)
let dynamic = response.layout(for: .dynamic)
```

## Usage

```swift
import OneLayout

let request = LayoutApi.list()
// send with RequestBuilder
```

## Module layout

```
Sources/OneLayout/
├── API/           LayoutApi, LayoutViewMode
├── Layout/        ListLayoutsResponse, LayoutFull, Layout, LayoutCell, …
└── Display/       cameraAccessPoints(), LayoutCellGeometrySolver, SpecialLayoutResolver
```

## Tests

```bash
swift test
```
