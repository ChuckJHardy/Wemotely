import XCTest

extension XCUIApplication {
    func isSwitchOn(switchElement: XCUIElement) -> Bool {
        return switchElement.value.debugDescription == "Optional(1)"
    }

    func cellByIndex(in table: XCUIElement, index: Int) -> XCUIElement {
        return table.cells.element(boundBy: index)
    }

    func switchInCell(cell: XCUIElement) -> XCUIElement {
        return cell.switches.element(boundBy: 0)
    }
}
