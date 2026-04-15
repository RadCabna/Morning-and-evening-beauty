import SwiftUI

struct BarChartView: View {
    let entries: [BarEntry]
    let yAxisLabel: String

    private let barColor = Color(red: 0.22, green: 0.28, blue: 0.48)
    private let labelColor = Color(red: 0.45, green: 0.42, blue: 0.62)
    private let gridColor = Color(red: 0.55, green: 0.52, blue: 0.68).opacity(0.25)

    var body: some View {
        GeometryReader { geo in
            let maxVal   = entries.map(\.value).max() ?? 1
            let ticks    = yTicks(max: maxVal)
            let scale    = ticks.last ?? maxVal          // bars never exceed the top tick
            let yLabelWidth: CGFloat  = screenHeight * 0.048
            let xLabelHeight: CGFloat = screenHeight * 0.03
            let chartH   = geo.size.height - xLabelHeight
            let chartW   = geo.size.width - yLabelWidth

            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Rituals")
                        .font(.app(screenHeight * 0.013, weight: .semiBold))
                        .foregroundStyle(labelColor)
                        .frame(width: yLabelWidth - 4, alignment: .leading)
                        .padding(.bottom, screenHeight * 0.004)

                    ForEach(ticks.reversed(), id: \.self) { tick in
                        Text("\(Int(tick))")
                            .font(.app(screenHeight * 0.013))
                            .foregroundStyle(labelColor)
                            .frame(width: yLabelWidth - 4,
                                   height: chartH / CGFloat(ticks.count + 1))
                            .frame(maxHeight: .infinity, alignment: .top)
                    }

                    Text("Date:")
                        .font(.app(screenHeight * 0.013, weight: .semiBold))
                        .foregroundStyle(labelColor)
                        .frame(width: yLabelWidth - 4, height: xLabelHeight, alignment: .leading)
                }
                .frame(width: yLabelWidth, height: geo.size.height)

                ZStack(alignment: .bottomLeading) {
                    VStack(spacing: 0) {
                        ForEach(ticks.reversed(), id: \.self) { _ in
                            Divider()
                                .background(gridColor)
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .frame(height: chartH)

                    HStack(alignment: .bottom, spacing: screenHeight * 0.008) {
                        ForEach(entries) { entry in
                            VStack(spacing: screenHeight * 0.005) {
                                Spacer(minLength: 0)
                                RoundedRectangle(cornerRadius: screenHeight * 0.007, style: .continuous)
                                    .fill(barColor)
                                    .frame(height: max(4, chartH * CGFloat(entry.value / scale)))
                                Text(entry.label)
                                    .font(.app(screenHeight * 0.012))
                                    .foregroundStyle(labelColor)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                                    .frame(height: xLabelHeight)
                            }
                        }
                    }
                    .padding(.horizontal, screenHeight * 0.008)
                }
                .frame(width: chartW, height: geo.size.height)
            }
        }
    }

    private func yTicks(max: Double) -> [Double] {
        let step: Double = max > 40 ? 10 : (max > 20 ? 5 : (max > 10 ? 5 : 2))
        var ticks: [Double] = []
        var v = step
        while v < max {
            ticks.append(v)
            v += step
        }
        ticks.append(v)  // top tick is always ≥ max
        return ticks
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        BarChartView(
            entries: [
                BarEntry(label: "Mornin", value: 11),
                BarEntry(label: "Evenin", value: 9),
                BarEntry(label: "Date R", value: 20),
                BarEntry(label: "Spa Da", value: 25)
            ],
            yAxisLabel: "min"
        )
        .frame(height: 220)
        .padding(.horizontal, 20)
    }
}
