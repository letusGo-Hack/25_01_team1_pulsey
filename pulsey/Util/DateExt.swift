import Foundation

extension Date {
    func equals(_ other: Date, components: Set<Calendar.Component>, using calendar: Calendar = .current) -> Bool {
        let selfComponents = calendar.dateComponents(components, from: self)
        let otherComponents = calendar.dateComponents(components, from: other)
        return selfComponents == otherComponents
    }
}
