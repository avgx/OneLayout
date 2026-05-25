import Foundation
import OneWireFormat

/// Resolves proportional cell frames from layout sibling geometry.
///
/// Port of webclient `solvePositions` (`layout.ts`). UI should force landscape when using these frames.
public enum LayoutCellGeometrySolver {
    public static func frames(for layout: Layout) -> [LayoutCellFrame] {
        solvePositions(cells: layout.cells, corner: .leftTop)
            .map { solved in
                let cameraAP = solved.cell.cameraAccessPoint
                let accessPoint: AccessPoint? = cameraAP.isEmpty ? nil : cameraAP
                return LayoutCellFrame(
                    position: solved.cell.position,
                    cameraAccessPoint: accessPoint,
                    left: solved.position.left,
                    top: solved.position.top,
                    right: solved.position.right,
                    bottom: solved.position.bottom
                )
            }
            .sorted { $0.position < $1.position }
    }

    private enum Corner {
        case leftTop
        case rightBottom
    }

    private struct NormalizedPosition: Equatable {
        var left: Double = 0
        var top: Double = 0
        var right: Double = 0
        var bottom: Double = 0
    }

    private struct SolvedCell {
        let cell: LayoutCell
        let position: NormalizedPosition
    }

    private enum Side: CaseIterable {
        case left
        case top
        case right
        case bottom

        var mirror: Side {
            switch self {
            case .left: return .right
            case .right: return .left
            case .top: return .bottom
            case .bottom: return .top
            }
        }

        var offsetKey: WritableKeyPath<NormalizedPosition, Double> {
            switch self {
            case .left: return \.left
            case .top: return \.top
            case .right: return \.right
            case .bottom: return \.bottom
            }
        }

        func siblingPosition(of cell: LayoutCell) -> Int {
            switch self {
            case .left: return cell.leftSiblingPosition
            case .top: return cell.topSiblingPosition
            case .right: return cell.rightSiblingPosition
            case .bottom: return cell.bottomSiblingPosition
            }
        }

        func sideWidth(of cell: LayoutCell) -> Double {
            switch self {
            case .left, .right: return cell.dimensions.width
            case .top, .bottom: return cell.dimensions.height
            }
        }
    }

    private static func solvePositions(
        cells: [String: LayoutCell],
        corner: Corner
    ) -> [SolvedCell] {
        guard !cells.isEmpty else { return [] }

        let (horizontal, vertical): (Side, Side) = switch corner {
        case .leftTop: (.left, .top)
        case .rightBottom: (.right, .bottom)
        }

        let cellsByPosition = cells
        let cellList = Array(cellsByPosition.values)

        let absolute = cellList.map { traversePosition(cells: cellsByPosition, cell: $0) }

        guard let cornerCell = absolute.first(where: { solved in
            isEdge(solved.cell, side: horizontal) && isEdge(solved.cell, side: vertical)
        }) else {
            return []
        }

        let offsetHorizontal = horizontal.mirror.offsetKey
        let offsetVertical = vertical.mirror.offsetKey
        let gridWidth = cornerCell.position[keyPath: offsetHorizontal] + cornerCell.cell.dimensions.width
        let gridHeight = cornerCell.position[keyPath: offsetVertical] + cornerCell.cell.dimensions.height

        guard gridWidth > 0, gridHeight > 0 else { return [] }

        return absolute.map { solved in
            SolvedCell(
                cell: solved.cell,
                position: NormalizedPosition(
                    left: solved.position.left / gridWidth,
                    top: solved.position.top / gridHeight,
                    right: solved.position.right / gridWidth,
                    bottom: solved.position.bottom / gridHeight
                )
            )
        }
    }

    private static func isEdge(_ cell: LayoutCell, side: Side) -> Bool {
        side.siblingPosition(of: cell) == -1
    }

    private static func layoutCell(at position: Int, in cells: [String: LayoutCell]) -> LayoutCell? {
        cells[String(position)]
    }

    private static func traverseToEdge(
        cells: [String: LayoutCell],
        side: Side,
        from cell: LayoutCell
    ) -> [LayoutCell] {
        var chain: [LayoutCell] = []
        var siblingPosition = side.siblingPosition(of: cell)

        while siblingPosition != -1, let next = layoutCell(at: siblingPosition, in: cells) {
            chain.append(next)
            siblingPosition = side.siblingPosition(of: next)
        }

        return chain
    }

    private static func traversePosition(
        cells: [String: LayoutCell],
        cell: LayoutCell
    ) -> SolvedCell {
        var position = NormalizedPosition()

        for side in Side.allCases {
            let offset = traverseToEdge(cells: cells, side: side, from: cell)
                .reduce(0.0) { partial, current in
                    partial + side.sideWidth(of: current)
                }
            position[keyPath: side.offsetKey] = offset
        }

        return SolvedCell(cell: cell, position: position)
    }
}
