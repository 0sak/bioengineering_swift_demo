//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation

private extension Decimal {
    var currency: String { self.formatted(.currency(code: "USD")) }
}

extension Decimal {
    var asDouble: Double { Double(truncating: self as NSNumber) }
}

extension StockData.StockPrice {
    
    var isClosingHigher: Bool {
        self.open < self.close
    }
    
    var accessibilityTrendSummary: String {
        "Price movement: \(isClosingHigher ? "up" : "down")"
    }
    
    var accessibilityDescription: String {
        return "Open: \(self.open.currency), Close: \(self.close.currency), High: \(self.high.currency), Low: \(self.low.currency)"
    }
}

enum StockData {
    struct StockPrice: Identifiable {
        let timestamp: Date
        let open: Decimal
        let high: Decimal
        let low: Decimal
        let close: Decimal
        
        var id: Date { timestamp }
    }

    static var apple: [StockPrice] {
        var prices: [StockPrice] = []
        for index in AppleStock.timestamps.indices {
            prices.append(
                .init(
                    timestamp: Date(timeIntervalSince1970: AppleStock.timestamps[index]),
                    open: AppleStock.opens[index],
                    high: AppleStock.highs[index],
                    low: AppleStock.lows[index],
                    close: AppleStock.closes[index]
                )
            )
        }
        return prices
    }

    static var appleFirst7Months: [StockPrice] {
        var prices: [StockPrice] = []
        for index in 0...7 {
            prices.append(
                .init(
                    timestamp: Date(timeIntervalSince1970: AppleStock.timestamps[index]),
                    open: AppleStock.opens[index],
                    high: AppleStock.highs[index],
                    low: AppleStock.lows[index],
                    close: AppleStock.closes[index]
                )
            )
        }
        return prices
    }

    enum AppleStock {
        static let timestamps: [TimeInterval] = [
            1498881600,
            1501560000,
            1504238400,
            1506830400,
            1509508800,
            1512104400,
            1514782800,
            1517461200,
            1519880400,
            1522555200,
            1525147200,
            1527825600,
            1530417600,
            1533096000,
            1535774400,
            1538366400,
            1541044800,
            1543640400,
            1546318800,
            1548997200,
            1551416400,
            1554091200,
            1556683200,
            1559361600,
            1561953600,
            1564632000,
            1567310400,
            1569902400,
            1572580800,
            1575176400,
            1577854800,
            1580533200,
            1583038800,
            1585713600,
            1588305600,
            1590984000,
            1593576000,
            1596254400,
            1598932800,
            1601524800,
            1604203200,
            1606798800,
            1609477200,
            1612155600,
            1614574800,
            1617249600,
            1619841600,
            1622520000,
            1625112000,
            1627790400,
            1630468800,
            1633060800,
            1635739200,
            1638334800,
            1641013200,
            1643691600,
            1646110800,
            1648785600,
            1651377600,
            1654056000,
            1655496005
        ]

        static let highs: [Decimal] = [
            38.497501373291016,
            41.130001068115234,
            41.23500061035156,
            42.412498474121094,
            44.060001373291016,
            44.29999923706055,
            45.025001525878906,
            45.154998779296875,
            45.875,
            44.73500061035156,
            47.592498779296875,
            48.54999923706055,
            48.9900016784668,
            57.217498779296875,
            57.41749954223633,
            58.36750030517578,
            55.59000015258789,
            46.23500061035156,
            42.25,
            43.967498779296875,
            49.42250061035156,
            52.119998931884766,
            53.82749938964844,
            50.39250183105469,
            55.342498779296875,
            54.50749969482422,
            56.60499954223633,
            62.4375,
            67.0,
            73.49250030517578,
            81.9625015258789,
            81.80500030517578,
            76.0,
            73.63249969482422,
            81.05999755859375,
            93.09500122070312,
            106.41500091552734,
            131.0,
            137.97999572753906,
            125.38999938964844,
            121.98999786376953,
            138.7899932861328,
            145.08999633789062,
            137.8800048828125,
            128.72000122070312,
            137.07000732421875,
            134.07000732421875,
            137.41000366210938,
            150.0,
            153.49000549316406,
            157.25999450683594,
            153.1699981689453,
            165.6999969482422,
            182.1300048828125,
            182.94000244140625,
            176.64999389648438,
            179.61000061035156,
            178.49000549316406,
            166.47999572753906,
            151.74000549316406,
            133.07899475097656
        ]

        static let closes: [Decimal] = [
            37.182498931884766,
            41.0,
            38.529998779296875,
            42.2599983215332,
            42.962501525878906,
            42.307498931884766,
            41.85749816894531,
            44.529998779296875,
            41.94499969482422,
            41.314998626708984,
            46.717498779296875,
            46.27750015258789,
            47.5724983215332,
            56.907501220703125,
            56.435001373291016,
            54.71500015258789,
            44.64500045776367,
            39.435001373291016,
            41.61000061035156,
            43.287498474121094,
            47.48749923706055,
            50.16749954223633,
            43.76750183105469,
            49.47999954223633,
            53.2599983215332,
            52.185001373291016,
            55.99250030517578,
            62.189998626708984,
            66.8125,
            73.4124984741211,
            77.37750244140625,
            68.33999633789062,
            63.5724983215332,
            73.44999694824219,
            79.48500061035156,
            91.19999694824219,
            106.26000213623047,
            129.0399932861328,
            115.80999755859375,
            108.86000061035156,
            119.05000305175781,
            132.69000244140625,
            131.9600067138672,
            121.26000213623047,
            122.1500015258789,
            131.4600067138672,
            124.61000061035156,
            136.9600067138672,
            145.86000061035156,
            151.8300018310547,
            141.5,
            149.8000030517578,
            165.3000030517578,
            177.57000732421875,
            174.77999877929688,
            165.1199951171875,
            174.61000061035156,
            157.64999389648438,
            148.83999633789062,
            131.55999755859375,
            131.55999755859375
        ]

        static let opens: [Decimal] = [
            36.220001220703125,
            37.275001525878906,
            41.20000076293945,
            38.564998626708984,
            42.467498779296875,
            42.48749923706055,
            42.540000915527344,
            41.79249954223633,
            44.6349983215332,
            41.65999984741211,
            41.602500915527344,
            46.997501373291016,
            45.95500183105469,
            49.782501220703125,
            57.102500915527344,
            56.98749923706055,
            54.76250076293945,
            46.1150016784668,
            38.72249984741211,
            41.7400016784668,
            43.56999969482422,
            47.90999984741211,
            52.470001220703125,
            43.900001525878906,
            50.79249954223633,
            53.474998474121094,
            51.60749816894531,
            56.26750183105469,
            62.3849983215332,
            66.81749725341797,
            74.05999755859375,
            76.07499694824219,
            70.56999969482422,
            61.625,
            71.5625,
            79.4375,
            91.27999877929688,
            108.19999694824219,
            132.75999450683594,
            117.63999938964844,
            109.11000061035156,
            121.01000213623047,
            133.52000427246094,
            133.75,
            123.75,
            123.66000366210938,
            132.0399932861328,
            125.08000183105469,
            136.60000610351562,
            146.36000061035156,
            152.8300018310547,
            141.89999389648438,
            148.99000549316406,
            167.47999572753906,
            177.8300018310547,
            174.00999450683594,
            164.6999969482422,
            174.02999877929688,
            156.7100067138672,
            149.89999389648438,
            130.06500244140625
        ]

        static let lows: [Decimal] = [
            35.602500915527344,
            37.102500915527344,
            37.290000915527344,
            38.1150016784668,
            41.31999969482422,
            41.6150016784668,
            41.17499923706055,
            37.560001373291016,
            41.23500061035156,
            40.157501220703125,
            41.317501068115234,
            45.182498931884766,
            45.85499954223633,
            49.32749938964844,
            53.82500076293945,
            51.522499084472656,
            42.564998626708984,
            36.647499084472656,
            35.5,
            41.48249816894531,
            42.375,
            47.095001220703125,
            43.747501373291016,
            42.567501068115234,
            49.602500915527344,
            48.14500045776367,
            51.05500030517578,
            53.782501220703125,
            62.290000915527344,
            64.07250213623047,
            73.1875,
            64.09249877929688,
            53.15250015258789,
            59.224998474121094,
            71.4625015258789,
            79.30249786376953,
            89.1449966430664,
            107.89250183105469,
            103.0999984741211,
            107.72000122070312,
            107.31999969482422,
            120.01000213623047,
            126.37999725341797,
            118.38999938964844,
            116.20999908447266,
            122.48999786376953,
            122.25,
            123.12999725341797,
            135.75999450683594,
            144.5,
            141.27000427246094,
            138.27000427246094,
            147.47999572753906,
            157.8000030517578,
            154.6999969482422,
            152.0,
            150.10000610351562,
            155.3800048828125,
            132.61000061035156,
            129.0399932861328,
            129.80999755859375
        ]
    }
}
