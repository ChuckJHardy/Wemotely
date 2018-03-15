import XCTest

extension XCUIApplication {
    func isSwitchOn(switchElement: XCUIElement) -> Bool {
        return switchElement.value.debugDescription == "Optional(1)"
    }

    func cellByIndex(table: XCUIElement, index: Int) -> XCUIElement {
        return table.cells.element(boundBy: index)
    }

    func switchInCell(cell: XCUIElement) -> XCUIElement {
        return cell.switches.element(boundBy: 0)
    }

    func forCell(in table: XCUIElement, run block: (_ index: Int) -> Void) {
        for index in 0..<table.cells.count {
            block(index)
        }
    }
}
