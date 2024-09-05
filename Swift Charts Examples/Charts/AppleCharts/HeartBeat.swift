//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts
import SwiftData
import PeakSwift

struct HeartBeat: View {
    var isOverview: Bool
    var data1 : [Double]?
    var title : String
    
    @State private var data = HealthData.ecgSample
    @State private var lineWidth = 1.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .pink
    @State private var preprocessData_b = false
    @State private var jPeaks_b = false
    
    var body: some View {
        if isOverview {
            chartAndLabels
        } else {
            List {
                Section {
                    chartAndLabels
                }
                customisation
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
    
    private var chartAndLabels: some View {
        VStack(alignment: .leading) {
            /*Text(title)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)*/
            Group {
                Text(Date(), style: .date) +
                Text(" at ") +
                Text(Date(), style: .time)
            }
            .foregroundColor(.secondary)
            chart
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("")
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: Constants.detailChartHeight)
    }
    
    private var chart: some View {
        Chart {
            let preprocess = self.preprocessSignal(ecgSignal: data1 ?? data, samplingFrequency: 1000.0)
            let jpeaks = self.calc_rpeaks(ecg: preprocessData_b ? ((preprocess) ?? data) : ((data1) ?? data), samplingRate: 1000.0)
            let jpeaks_and_distance = self.calc_distance_between(data: jpeaks ?? [300,800,1200])
            
            ForEach(Array(preprocessData_b ? (preprocess.enumerated() ?? data.enumerated()) : (data1?.enumerated() ?? data.enumerated())), id: \.element) { index, element in
                LineMark(
                    x: .value("Seconds", Double(index)/1000.0),
                    y: .value("Unit", element)
                )
                .lineStyle(StrokeStyle(lineWidth: lineWidth))
                .foregroundStyle(chartColor)
                .interpolationMethod(interpolationMethod.mode)
                .accessibilityLabel("\(index)s")
                .accessibilityValue("\(element) mV")
                .accessibilityHidden(isOverview)
            }
            if(jPeaks_b){
                ForEach(Array(jpeaks_and_distance.keys), id: \.self) { key in
                    RuleMark(x: .value("J-J Peaks", key))
                        .foregroundStyle(.yellow)
                        .lineStyle(StrokeStyle(lineWidth: lineWidth))
                        .annotation(position: .trailing, alignment: .leading, spacing: 4) {
                            Text(String(format: "%.1f", jpeaks_and_distance[key]!))
                                .font(.caption)
                                .rotationEffect(.degrees(-90))
                        }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 12)) { value in
                if let doubleValue = value.as(Double.self),
                   let intValue = value.as(Int.self) {
                    if doubleValue - Double(intValue) == 0 {
                        AxisTick(stroke: .init(lineWidth: 1))
                            .foregroundStyle(.gray)
                        AxisValueLabel() {
                            Text("\(intValue)s")
                        }
                        AxisGridLine(stroke: .init(lineWidth: 1))
                            .foregroundStyle(.gray)
                    } else {
                        AxisGridLine(stroke: .init(lineWidth: 1))
                            .foregroundStyle(.gray.opacity(0.25))
                    }
                }
            }
        }
        .chartYScale(domain: getChartYScale)
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 14)) { value in
                AxisGridLine(stroke: .init(lineWidth: 1))
                    .foregroundStyle(.gray.opacity(0.25))
            }
        }
        .chartPlotStyle {
            $0.border(Color.gray)
        }
        .accessibilityChartDescriptor(self)
    }
    
    private var customisation: some View {
        Section {
            Toggle("Hamilton?", isOn: $preprocessData_b)
            
            Toggle("Nabian2018?", isOn: $jPeaks_b)
            
            VStack(alignment: .leading) {
                Text("Line Width: \(lineWidth, specifier: "%.1f")")
                Slider(value: $lineWidth, in: 0...1) {
                    Text("Line Width")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
            
            
        }
    }
    
    private var getChartYScale: ClosedRange<Float> {
        if (title == "Neurokit Simulated ECG") {return -1...1.3}
        let buffer = preprocessData_b ? Float(-6.0)...Float(6.0) : Float(-8.0)...Float(8.0)
        return buffer
        }
    
    private var rpeaks : [Double]{
        return [0.0]
    }

    func calc_rpeaks(ecg: [Double], samplingRate: Double)-> [Double] {
        var result = [Double]()
        let electrocardiogram = Electrocardiogram(ecg: ecg, samplingRate: samplingRate)
        
        let qrsDetector = QRSDetector()

        let qrsResult = qrsDetector.detectPeaks(electrocardiogram: electrocardiogram, algorithm: .nabian2018)
        
        let rPeaks = qrsResult.rPeaks
        _ = qrsResult.cleanedElectrocardiogram
        
        //print(cleanedSignal.ecg
        
        for i in 0 ..< rPeaks.count {
            let buffer = (Double(rPeaks[i]))
            result.append(buffer / 1000.0)
        }
        
        return result
    }
    
    func calc_distance_between(data : [Double]) -> [Double: Double]{
        //var buffer = [Double]()
        var result : [Double: Double] = [:]

        
        for i in 0 ..< (data.count){
            result[data[i]] = (data[i] * 1000.0)
        }
    
        //print(data[(data.count)])
         /*
        for i in 0 ..< (data.count){
             result[data[i]] = 0.0
         }
         
        if(data.count % 2 == 0){
            for i in 0 ..< (data.count-1){
                result[data[i]] = data[i+1] - data[i]
            }
        }
        else{
            for i in 0 ..< (data.count-1){
                result[data[i]] = data[i+1] - data[i]
            }
            result[data[data.count]] = 0
        }
        */
        print(result)
        return result
    }
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        Butterworth().butterworth(signal: ecgSignal, order: .one, lowCutFrequency: 8, highCutFrequency: 16, sampleRate: samplingFrequency)
    }
}

// MARK: - Accessibility

extension HeartBeat: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let min = data1?.min() ?? 0.0
        let max = data1?.max() ?? 0.0
        
        // Set the units when creating the axes
        // so users can scrub and pause to narrow on a data point
        let xAxis = AXNumericDataAxisDescriptor(
            title: "Time",
            range: Double(0)...Double(data1?.count ?? data.count),
            gridlinePositions: []
        ) { value in "\(value)s" }
        
        
        let yAxis = AXNumericDataAxisDescriptor(
            title: "Millivolts",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(value) mV" }
        
        let series = AXDataSeriesDescriptor(
            name: "ECG data",
            isContinuous: true,
            dataPoints: (data1?.enumerated().map {
                .init(x: Double($0), y: $1)
            })!
        )
        
        return AXChartDescriptor(
            title: "ElectroCardiogram (ECG)",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

// MARK: - Preview

struct HeartBeat_Previews: PreviewProvider {
    static var previews: some View {
        HeartBeat(isOverview: true, data1:[0.0], title:"Neurokit2 ECG Simulated Data")
        HeartBeat(isOverview: false, data1:[0.0], title:"Neurokit2 ECG Simulated Data")
    }
}

/*
 struct ContentView: View {
     let dict = ["key1": "value1", "key2": "value2"]
     
     var body: some View {
         List {
             ForEach(dict.sorted(by: >), id: \.key) { key, value in
                 Section(header: Text(key)) {
                     Text(value)
                 }
             }
         }
     }
 }
 */
