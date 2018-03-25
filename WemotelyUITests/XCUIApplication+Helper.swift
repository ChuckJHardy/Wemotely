import XCTest

extension XCUIApplication {
    func isSwitchOn(switchElement: XCUIElement) -> Bool {
        return switchElement.value.debugDescription == "Optional(1)"
    }

    func cellByIndex(table: XCUIElement, index: Int) -> XCUIElement {
        return table.cells.element(boundBy: index)
    }

    func cellByLabel(table: XCUIElement, label: String) -> XCUIElement {
        return table
            .children(matching: .cell)
            .element(boundBy: 0)
            .staticTexts[label]
    }

    func countInDashboardCell(table: XCUIElement, position: Int = 0) -> Int {
        return Int(
            labelInCell(
                cell: cellByIndex(table: table, index: position),
                position: 1
            )
        )!
    }

    func switchInCell(cell: XCUIElement) -> XCUIElement {
        return cell.switches.element(boundBy: 0)
    }

    func labelInCell(cell: XCUIElement, position: Int = 0) -> String {
        return cell.staticTexts.element(boundBy: position).label
    }

    func forCell(in table: XCUIElement, run block: (_ index: Int) -> Void) {
        for index in 0..<table.cells.count {
            block(index)
        }
    }
}
