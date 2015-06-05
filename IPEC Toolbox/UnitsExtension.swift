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
        
        case "Molar Density":
            switch unit {
            case "mole/m3": temp = self.molePerM3
            case "mole/cm3": temp = self.molePerCm3
            case "mole/gallon": temp = self.molePerGallon
            case "mole/liter": temp = self.molePerLiter
            case "mole/ft3": temp = self.molePerFt3
            default: return nil
            }
            switch toUnit {
            case "mole/m3": return temp.molePerM3
            case "mole/cm3": return temp.toMolePerCm3
            case "mole/gallon": return temp.toMolePerGallon
            case "mole/liter": return temp.toMolePerLiter
            case "mole/ft3": return temp.toMolePerFt3
            default: return nil
            }
            
        case "Density":
            switch unit {
            case "kg/m3": temp = self.kgPerM3
            case "g/m3": temp = self.gPerM3
            case "g/cm3": temp = self.gPerCm3
            case "lb/ft3": temp = self.lbPerFt3
            case "lb/in3": temp = self.lbPerIn3
            default: return nil
            }
            switch toUnit {
            case "kg/m3": return temp.kgPerM3
            case "g/m3": return temp.toGPerM3
            case "g/cm3": return temp.toGPerCm3
            case "lb/ft3": return temp.toLbPerFt3
            case "lb/in3": return temp.toLbPerIn3
            default: return nil
            }
            
        case "Inverse Volume":
            switch unit {
            case "1/m3": temp = self.onePerM3
            case "1/cm3": temp = self.onePerCm3
            case "1/gallon": temp = self.onePerGallon
            case "1/liter": temp = self.onePerLiter
            case "1/ft3": temp = self.onePerFt3
            default: return nil
            }
            switch toUnit {
            case "1/m3": return temp.onePerM3
            case "1/cm3": return temp.toOnePerCm3
            case "1/gallon": return temp.toOnePerGallon
            case "1/liter": return temp.toOnePerLiter
            case "1/ft3": return temp.toOnePerFt3
            default: return nil
            }
        
        case "Length":
            switch unit {
            case "m": temp = self.m
            case "cm": temp = self.cm
            case "mm": temp = self.mm
            case "ft": temp = self.ft
            case "in": temp = self.inch
            default: return nil
            }
            switch toUnit {
            case "m": return temp.m
            case "cm": return temp.toCm
            case "mm": return temp.toMm
            case "ft": return temp.toFt
            case "in": return temp.toInch
            default: return nil
            }

        case "Force Per Length":
            switch unit {
            case "N/m": temp = self.NPerM
            case "kN/m": temp = self.kNPerM
            case "kgf/m": temp = self.kgfPerM
            case "lbf/ft": temp = self.lbfPerFt
            default: return nil
            }
            switch toUnit {
            case "N/m": return temp.NPerM
            case "kN/m": return temp.toKNPerM
            case "kgf/m": return temp.toKgfPerM
            case "lbf/ft": return temp.toLbfPerFt
            default: return nil
            }


        default: return self
        }
    }
}

extension Double { //Temperature
    private var celsius: Double { return self }
    
    private var farenheit: Double { return (self - 32.0) * (5.0/9.0) }
    private var kelvin: Double { return self - 273.15 }
    
    private var toFarenheit: Double { return self * 1.8 + 32.0 }
    private var toKelvin: Double { return self + 273.15 }
}

extension Double { //Pressure
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

extension Double { //Molar Density
    private var molePerM3: Double { return self }
    
    private var molePerCm3: Double { return self * pow(10.0, 6.0) }
    private var molePerGallon: Double { return self * 264.17 }
    private var molePerLiter: Double { return self * 1_000 }
    private var molePerFt3: Double { return self / pow(0.3048, 3.0) }

    private var toMolePerCm3: Double { return self / pow(10.0, 6.0) }
    private var toMolePerGallon: Double { return self / 264.17 }
    private var toMolePerLiter: Double { return self / 1_000 }
    private var toMolePerFt3: Double { return self * pow(0.3048, 3.0) }

}

extension Double { //Density
    private var kgPerM3: Double { return self }
    
    private var gPerCm3: Double { return self * 1_000 }
    private var gPerM3: Double { return self / 1_000 }
    private var lbPerFt3: Double { return self * 16.018733 }
    private var lbPerIn3: Double { return self * 27_680.370 }
    
    private var toGPerCm3: Double { return self / 1_000 }
    private var toGPerM3: Double { return self * 1_000 }
    private var toLbPerFt3: Double { return self / 16.018733 }
    private var toLbPerIn3: Double { return self / 27_680.370 }

}

extension Double { //Inverse Volume
    private var onePerM3: Double { return self }
    
    private var onePerCm3: Double { return self * pow(10.0, 6.0) }
    private var onePerGallon: Double { return self * 264.17217686 }
    private var onePerLiter: Double { return self * 1_000 }
    private var onePerFt3: Double { return self * 35.3147 }
    
    private var toOnePerCm3: Double { return self / pow(10.0, 6.0) }
    private var toOnePerGallon: Double { return self / 264.17217686 }
    private var toOnePerLiter: Double { return self / 1_000 }
    private var toOnePerFt3: Double { return self / 35.3147 }
}

extension Double { //Length
    private var m: Double { return self }

    private var cm: Double { return self / 100.0 }
    private var mm: Double { return self / 1_000.0 }
    private var ft: Double { return self * 0.3048 }
    private var inch: Double { return self * 0.0254 }
    
    private var toCm: Double { return self * 100.0 }
    private var toMm: Double { return self * 1_000.0 }
    private var toFt: Double { return self / 0.3048 }
    private var toInch: Double { return self / 0.0254 }
}

extension Double { //Force Per Length
    private var NPerM: Double { return self }
    
    private var kNPerM: Double { return self * 1_000.0 }
    private var kgfPerM: Double { return self / 0.101971 }
    private var lbfPerFt: Double { return self / (0.224809 / 3.28083) }
    
    private var toKNPerM: Double { return self / 1_000.0 }
    private var toKgfPerM: Double { return self * 0.101971 }
    private var toLbfPerFt: Double { return self * (0.224809 / 3.28083) }

}


