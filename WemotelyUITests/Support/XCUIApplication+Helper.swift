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

    func countCellsInTable(table: XCUIElement) -> Int {
        table.swipeUp() // Fix: Ensure all cells are dequeued before getting the count
        table.swipeDown()
        return table.cells.count
    }

    func countInDashboardCell(table: XCUIElement, position: Int = 0) -> Int {
        return Int(
            labelInCell(
                cell: cellByIndex(table: table, index: position),
                position: 1
            )
        )!
    }

    func swipeAndDelete(table: XCUIElement, label: String) {
        let cell = cellByLabel(table: table, label: label)
        cell.swipeLeft()
        table.buttons["Delete"].tap()
    }

    func swipeAndUndelete(table: XCUIElement, label: String) {
        let cell = cellByLabel(table: table, label: label)
        cell.swipeLeft()
        table.buttons["Undelete"].tap()
    }

    func swipeAndFavourite(table: XCUIElement, label: String) {
        let cell = cellByLabel(table: table, label: label)
        cell.swipeRight()
        table.buttons["Favourite"].tap()
    }

    func swipeAndUnfavourite(table: XCUIElement, label: String) {
        let cell = cellByLabel(table: table, label: label)
        cell.swipeRight()
        table.buttons["Unfavourite"].tap()
    }

    func switchInCell(cell: XCUIElement) -> XCUIElement {
        return cell.switches.element(boundBy: 0)
    }

    func labelInCell(cell: XCUIElement, position: Int = 0) -> String {
        return cell.staticTexts.element(boundBy: position).label
    }

    func forCell(in table: XCUIElement, run block: (_ index: Int) -> Void) {
        for index in 0..<self.countCellsInTable(table: table) {
            block(index)
        }
    }

    func iconInToolbar(toolbar: XCUIElement, position: Int = 0) -> XCUIElement {
        return toolbar
            .children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .button)
            .element(boundBy: position)
    }

    func pullToRefresh(cell: XCUIElement, threshold: Int = 10) {
        let startPosition = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let endPosition = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: threshold))
        startPosition.press(forDuration: 0, thenDragTo: endPosition)
    }
}
