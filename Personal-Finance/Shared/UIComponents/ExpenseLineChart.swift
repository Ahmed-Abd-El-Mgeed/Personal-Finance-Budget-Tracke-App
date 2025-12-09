//
//  ExpenseLineChart.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 09/12/2025.
//

import SwiftUI
import Charts

struct ExpenseLineChart: View {
    let data: [ExpenseDataPoint]      
    @Binding var selectedLabel: String?
    
    var body: some View {
        Chart(data) { item in
            
            LineMark(
                x: .value("Period", item.label),
                y: .value("Value", item.value)
            )
            .foregroundStyle(Color.black)
            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .interpolationMethod(.catmullRom)
            
            AreaMark(
                x: .value("Period", item.label),
                y: .value("Value", item.value)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.gray.opacity(0.3), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)

            if selectedLabel == item.label {
                PointMark(
                    x: .value("Period", item.label),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(.black)
                .symbolSize(100)

                RuleMark(x: .value("Period", item.label))
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5,5]))
                    .annotation(position: .bottom) {
                        VStack {
                            Text(item.label)
                                .bold()
                            Text("value: \(Int(item.value))")
                        }
                        .padding(10)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    }
            }
        }
        .frame(height: 200)
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks { value in
                if let label = value.as(String.self) {
                    AxisValueLabel {
                        Text(label)
                            .foregroundColor(selectedLabel == label ? .black : .gray)
                            .fontWeight(selectedLabel == label ? .semibold : .regular)
                            .onTapGesture {
                                selectedLabel = label
                            }
                    }
                }
            }
        }
        .chartXSelection(value: $selectedLabel)
    }
}

