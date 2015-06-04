//
//  UnitsExtension.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/6/1.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import Foundation

extension Double {
    func convert(fromUnit unit:String, toUnit: String, kind: String) -> Double? {
        var temp = Double()
        
        switch kind {
        case "Temperature":
            switch unit {
                case "°C": temp = self.celsius
                case "K": temp = self.kelvin
                case "°F": temp = self.farenheit
                default: return nil
            }
            switch toUnit {
                case "°C": return temp.celsius
                case "K": return temp.toKelvin
                case "°F": return temp.toFarenheit
                default: return nil
            }
            
        case "Pressure":
            switch unit {
                case "Pa": temp = self.pascale
                case "kPa": temp = self.kiloPascale
                case "bar": temp = self.bar
                case "millibar": temp = self.milliBar
                case "psi": temp = self.psi
                case "ksi": temp = self.ksi
                default: return nil
            }
            switch toUnit {
                case "Pa": return temp.pascale
                case "kPa": return temp.toKiloPascale
                case "bar": return temp.toBar
                case "millibar": return temp.toMilliBar
                case "psi": return temp.toPsi
                case "ksi": return temp.toKsi
                default: return nil
            }

        default: return nil
        }
    }
}

extension Double {
    private var celsius: Double { return self }
    private var farenheit: Double { return (self - 32.0) * (5.0/9.0) }
    private var kelvin: Double { return self - 273.15 }
    
    private var toFarenheit: Double { return self * 1.8 + 32.0 }
    private var toKelvin: Double { return self + 273.15 }
}

extension Double {
    private var pascale: Double { return self }
    private var kiloPascale: Double { return self * 1_000}
    private var bar: Double { return self * 100_000 }
    private var milliBar: Double { return self * 100 }
    private var psi: Double { return self * 6_894.76 }
    private var ksi: Double { return self * 6_894_760 }
    
    private var toKiloPascale: Double { return self * 0.001 }
    private var toBar: Double { return self * 0.01 / 1000.0 }
    private var toMilliBar: Double { return self * 0.01 }
    private var toPsi: Double { return self * 0.1450376807 / 1000.0 }
    private var toKsi: Double { return self * 0.00014503768 / 1000.0 }
}


