import SwiftUI
import Darwin

struct PieChartView: View {
    let slices: [PieSlice]

    var body: some View {
        let total = slices.map(\.value).reduce(0, +)

        Canvas { ctx, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2

            var startAngle = Angle.degrees(-90)

            for slice in slices {
                let sweep = Angle.degrees(360 * slice.value / total)
                let endAngle = startAngle + sweep
                let midAngle = startAngle + sweep / 2

                var path = Path()
                path.move(to: center)
                path.addArc(center: center, radius: radius,
                            startAngle: startAngle, endAngle: endAngle,
                            clockwise: false)
                path.closeSubpath()
                ctx.fill(path, with: .color(slice.color))

                var divider = Path()
                divider.move(to: center)
                divider.addLine(to: CGPoint(
                    x: center.x + radius * CGFloat(Darwin.cos(startAngle.radians)),
                    y: center.y + radius * CGFloat(Darwin.sin(startAngle.radians))
                ))
                ctx.stroke(divider, with: .color(.white), lineWidth: 2)

                let labelR = radius * 0.68
                let labelX = center.x + labelR * CGFloat(Darwin.cos(midAngle.radians))
                let labelY = center.y + labelR * CGFloat(Darwin.sin(midAngle.radians))
                let pct = Int((slice.value / total) * 100)
                let resolved = ctx.resolve(
                    Text("\(slice.label)\n\(pct)%")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                )
                ctx.draw(resolved, at: CGPoint(x: labelX, y: labelY), anchor: .center)

                startAngle = endAngle
            }

            let dotR: CGFloat = 10

            var dot = Path()
            dot.addEllipse(in: CGRect(x: center.x - dotR, y: center.y - dotR,
                                      width: dotR * 2, height: dotR * 2))
            ctx.fill(dot, with: .color(.white))
        }
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        PieChartView(slices: [
            PieSlice(label: "Morning",       value: 30, color: Color(red: 1.0,  green: 0.82, blue: 0.45)),
            PieSlice(label: "Evening",       value: 25, color: Color(red: 0.35, green: 0.72, blue: 0.78)),
            PieSlice(label: "Makeup",        value: 20, color: Color(red: 0.52, green: 0.45, blue: 0.82)),
            PieSlice(label: "Spa",           value: 15, color: Color(red: 0.68, green: 0.45, blue: 0.82)),
            PieSlice(label: "Special Cases", value: 10, color: Color(red: 0.92, green: 0.55, blue: 0.52))
        ])
        .frame(width: 260, height: 260)
    }
}
