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

    func switchInCell(cell: XCUIElement) -> XCUIElement {
        return cell.switches.element(boundBy: 0)
    }

    func labelInCell(cell: XCUIElement) -> String {
        return cell.staticTexts.element(boundBy: 0).label
    }

    func forCell(in table: XCUIElement, run block: (_ index: Int) -> Void) {
        for index in 0..<table.cells.count {
            block(index)
        }
    }
}
