//
//  CalendarComponent.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//


import SwiftUI

struct CalendarComponent: View {
    @Environment(\.calendar) private var calendar
    @Binding var month: Date
    @Binding var selected: Date?
//    let products: [Product]
    
    @State private var currentMonthIndex: Int = 0
    private let baseDate = Date()

    var body: some View {
        VStack(spacing: 12) {
            yearMonthView
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            HStack(spacing: 0) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol.uppercased())
//                        .myFont(.labelR)
//                        .foregroundStyle(.label(.alternative))
                        .frame(maxWidth: .infinity)
                }
            }
            TabView(selection: $currentMonthIndex) {
                ForEach(-12...12, id: \.self) { index in
                    let targetMonth = calendar.date(byAdding: .month, value: index, to: baseDate)!
                    calendarContent(for: targetMonth)
                        .tag(index)
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 320)
        }
        .onChange(of: currentMonthIndex) { _, newIndex in
            if let updatedMonth = calendar.date(byAdding: .month, value: newIndex, to: baseDate) {
                month = updatedMonth
            }
        }
        .onAppear {
            currentMonthIndex = calendar.dateComponents([.month], from: baseDate, to: month).month ?? 0
        }
    }

    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            Button {
                currentMonthIndex -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .font(.subheadline)
//                    .foregroundStyle(.label(.normal))
            }
            .scaledButton()
            Text(month.toString("yyyy.MM"))
                .myFont(.headlineM)
                .foregroundStyle(.label(.normal))
            Button {
                currentMonthIndex += 1
            } label: {
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.label(.normal))
            }
            .scaledButton()
        }
    }

    private func calendarContent(for targetMonth: Date) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(monthDates(for: targetMonth), id: \.self) { date in
                CalendarCellView(
                    day: calendar.component(.day, from: date),
                    selected: selected?.equals(date, components: [.year, .month, .day], using: calendar) ?? false,
                    isToday: Date.now.equals(date, components: [.year, .month, .day], using: calendar),
                    isCurrentMonthDay: calendar.isDate(date, equalTo: targetMonth, toGranularity: .month),
                    hasProduct: products.contains {
                        $0.expirationDate.equals(date, components: [.year, .month, .day], using: calendar)
                    }
                ) {
                    self.selected = date
                }
            }
        }
    }

    private func monthDates(for month: Date) -> [Date] {
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return []
        }

        let numberOfDays = range.count
        let firstWeekdayIndex = calendar.component(.weekday, from: firstDay) - calendar.firstWeekday
        let prefixDays = (firstWeekdayIndex + 7) % 7
        let totalCells = Int(ceil(Double(prefixDays + numberOfDays) / 7.0)) * 7

        return (0..<totalCells).compactMap {
            calendar.date(byAdding: .day, value: $0 - prefixDays, to: firstDay)
        }
    }
}

private struct CalendarCellView: View {
    let day: Int
    let selected: Bool
    let isToday: Bool
    let isCurrentMonthDay: Bool
    let hasProduct: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    if isToday {
                        Circle()
                            .fill(.primary(.normal))
                            .frame(width: 32, height: 32)
                    } else if selected {
                        Circle()
                            .stroke(.label(.normal), lineWidth: 1)
                            .frame(width: 32, height: 32)
                    } else {
                        Circle()
                            .fill(.clear)
                            .frame(width: 32, height: 32)
                    }
                    Text("\(day)")
                        .foregroundColor(isToday ? .background(.normal) : .label(.normal))
                }
                Circle()
                    .fill(.primary(.normal))
                    .frame(width: 6, height: 6)
                    .opacity(hasProduct ? 1 : 0)
            }
        }
        .scaledButton()
        .disabled(!isCurrentMonthDay)
        .opacity(isCurrentMonthDay ? 1 : 0.5)
    }
}
