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
                case "MPa": temp = self.megaPascale
                case "GPa": temp = self.gigaPascale
                case "bar": temp = self.bar
                case "millibar": temp = self.milliBar
                case "psi": temp = self.psi
                case "ksi": temp = self.ksi
                default: return nil
            }
            switch toUnit {
                case "Pa": return temp.pascale
                case "kPa": return temp.toKiloPascale
                case "MPa": return temp.toMegaPascale
                case "GPa": return temp.toGigaPascale
                case "bar": return temp.toBar
                case "millibar": return temp.toMilliBar
                case "psi": return temp.toPsi
                case "ksi": return temp.toKsi
                default: return nil
            }
        
        case "Molar Density":
            switch unit {
            case "mole/m³": temp = self.molePerM3
            case "mole/cm³": temp = self.molePerCm3
            case "mole/gal": temp = self.molePerGallon
            case "mole/L": temp = self.molePerLiter
            case "mole/ft³": temp = self.molePerFt3
            default: return nil
            }
            switch toUnit {
            case "mole/m³": return temp.molePerM3
            case "mole/cm³": return temp.toMolePerCm3
            case "mole/gal": return temp.toMolePerGallon
            case "mole/L": return temp.toMolePerLiter
            case "mole/ft³": return temp.toMolePerFt3
            default: return nil
            }
            
        case "Density":
            switch unit {
            case "kg/m³": temp = self.kgPerM3
            case "g/m³": temp = self.gPerM3
            case "g/cm³": temp = self.gPerCm3
            case "lb/ft³": temp = self.lbPerFt3
            case "lb/in³": temp = self.lbPerIn3
            default: return nil
            }
            switch toUnit {
            case "kg/m³": return temp.kgPerM3
            case "g/m³": return temp.toGPerM3
            case "g/cm³": return temp.toGPerCm3
            case "lb/ft³": return temp.toLbPerFt3
            case "lb/in³": return temp.toLbPerIn3
            default: return nil
            }
            
        case "Inverse Volume":
            switch unit {
            case "1/m³": temp = self.onePerM3
            case "1/cm³": temp = self.onePerCm3
            case "1/gal": temp = self.onePerGallon
            case "1/L": temp = self.onePerLiter
            case "1/ft³": temp = self.onePerFt3
            default: return nil
            }
            switch toUnit {
            case "1/m³": return temp.onePerM3
            case "1/cm³": return temp.toOnePerCm3
            case "1/gal": return temp.toOnePerGallon
            case "1/L": return temp.toOnePerLiter
            case "1/ft³": return temp.toOnePerFt3
            default: return nil
            }
        
        case "Length":
            switch unit {
            case "m": temp = self.m
            case "cm": temp = self.cm
            case "mm": temp = self.mm
            case "ft": temp = self.ft
            case "in": temp = self.inch
            case "mi": temp = self.mi
            case "km": temp = self.km
            default: return nil
            }
            switch toUnit {
            case "m": return temp.m
            case "cm": return temp.toCm
            case "mm": return temp.toMm
            case "ft": return temp.toFt
            case "in": return temp.toInch
            case "mi": return temp.toMi
            case "km": return temp.toKm
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

        case "Volume Rate":
            switch unit {
            case "m³/s": temp = self.m3PerS
            case "m³/min": temp = self.m3PerMin
            case "m³/hr": temp = self.m3PerHr
            case "L/s": temp = self.literPerS
            case "L/min": temp = self.literPerMin
            case "L/hr": temp = self.literPerHr
            case "gal/s": temp = self.gallonPerS
            case "gal/min": temp = self.gallonPerMin
            case "gal/hr": temp = self.gallonPerHr
            case "ft³/s": temp = self.ft3PerS
            case "ft³/min": temp = self.ft3PerMin
            case "ft³/hr": temp = self.ft3PerHr
            default: return nil
            }
            switch toUnit {
            case "m³/s": return temp.m3PerS
            case "m³/min": return temp.toM3PerMin
            case "m³/hr": return temp.toM3PerHr
            case "L/s": return temp.toLiterPerS
            case "L/min": return temp.toLiterPerMin
            case "L/hr": return temp.toLiterPerHr
            case "gal/s": return temp.toGallonPerS
            case "gal/min": return temp.toGallonPerMin
            case "gal/hr": return temp.toGallonPerHr
            case "ft³/s": return temp.toFt3PerS
            case "ft³/min": return temp.toFt3PerMin
            case "ft³/hr": return temp.toFt3PerHr
            default: return nil
            }

        case "Viscosity":
            switch unit {
            case "Pa.s": temp = self.PaS
            case "N.s/m²": temp = self.NSPerM2
            case "Poise": temp = self.poise
            case "cPoise": temp = self.cPoise
            case "lb.s/ft²": temp = self.lbSPerFt2
            case "lb.s/in²": temp = self.lbSPerIn2
            default: return nil
            }
            switch toUnit {
            case "Pa.s": return temp.PaS
            case "N.s/m²": return temp.toNSPerM2
            case "Poise": return temp.toPoise
            case "cPoise": return temp.toCPoise
            case "lb.s/ft²": return temp.toLbSPerFt2
            case "lb.s/in²": return temp.toLbSPerIn2
            default: return nil
            }

        case "Mass":
            switch unit {
            case "kg": temp = self.kg
            case "g": temp = self.g
            case "ton": temp = self.ton
            case "lb": temp = self.lb
            default: return nil
            }
            switch toUnit {
            case "kg": return temp.kg
            case "g": return temp.toG
            case "ton": return temp.toTon
            case "lb": return temp.toLb
            default: return nil
            }

        case "Speed":
            switch unit {
            case "m/s": temp = self.mPerS
            case "km/h": temp = self.kmPerH
            case "ft/s": temp = self.ftPerS
            default: return nil
            }
            switch toUnit {
            case "m/s": return temp.mPerS
            case "km/h": return temp.toKmPerH
            case "ft/s": return temp.toFtPerS
            default: return nil
            }
            
        case "Heat Capacity":
            switch unit {
            case "J/(kg.°C)": temp = self.JPerKgC
            case "J/(kg.K)": temp = self.JPerKgK
            case "Btu/(lbm.R)": temp = self.btuPerLbmR
            default: return nil
            }
            switch toUnit {
            case "J/(kg.°C)": return temp.JPerKgC
            case "J/(kg.K)": return temp.toJPerKgK
            case "Btu/(lbm.R)": return temp.toBtuPerLbmR
            default: return nil
            }
            
        case "Thermal Conductivity":
            switch unit {
            case "W/(m.°C)": temp = self.WPerMC
            case "W/(m.K)": temp = self.WPerMK
            case "Cal/(m.hr.K)": temp = self.calPerMHrK
            case "Btu/(ft.hr.R)": temp = self.btuPerFtHrR
            default: return nil
            }
            switch toUnit {
            case "W/(m.°C)": return temp.WPerMC
            case "W/(m.K)": return temp.toWPerMK
            case "Cal/(m.hr.K)": return temp.toCalPerMHrK
            case "Btu/(ft.hr.R)": return temp.toBtuPerFtHrR
            default: return nil
            }
            
        case "Power Per Length":
            switch unit {
            case "W/m": temp = self.WPerM
            case "Cal/(m.hr)": temp = self.calPerMHr
            case "Btu/(ft.hr)": temp = self.btuPerFtHr
            default: return nil
            }
            switch toUnit {
            case "W/m": return temp.WPerM
            case "Cal/(m.hr)": return temp.toCalPerMHr
            case "Btu/(ft.hr)": return temp.toBtuPerFtHr
            default: return nil
            }

        case "Volume":
            switch unit {
            case "m³": temp = self.m3
            case "cm³": temp = self.cm3
            case "L": temp = self.L
            case "ft³": temp = self.ft3
            case "mi³": temp = self.mi3
            case "gallon": temp = self.gallon
            case "barrel": temp = self.barrel
            default: return nil
            }
            switch toUnit {
            case "m³": return temp.m3
            case "cm³": return temp.toCm3
            case "L": return temp.toL
            case "ft³": return temp.toFt3
            case "mi³": return temp.toMi3
            case "gallon": return temp.toGallon
            case "barrel": return temp.toBarrel
            default: return nil
            }


        default: return self
        }
    }
}

extension Double { //Mass
    private var kg: Double { return self }
    
    private var g: Double { return self / 1000.0 }
    private var ton: Double { return self * 1000.0 }
    private var lb: Double { return self * 0.45359 }
    
    private var toG: Double { return self * 1000.0 }
    private var toTon: Double { return self / 1000.0 }
    private var toLb: Double { return self / 0.45359 }
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
    private var megaPascale: Double { return self * 1_000_000 }
    private var gigaPascale: Double { return self * 1_000_000_000 }
    private var bar: Double { return self * 100_000 }
    private var milliBar: Double { return self * 100 }
    private var psi: Double { return self * 6_894.76 }
    private var ksi: Double { return self * 6_894_760 }
    
    private var toKiloPascale: Double { return self / 1000 }
    private var toMegaPascale: Double { return self / 1_000_000 }
    private var toGigaPascale: Double { return self / 1_000_000_000 }
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
    private var mi: Double { return self * 1609.34 }
    private var km: Double { return self * 1_000.0 }
    
    private var toCm: Double { return self * 100.0 }
    private var toMm: Double { return self * 1_000.0 }
    private var toFt: Double { return self / 0.3048 }
    private var toInch: Double { return self / 0.0254 }
    private var toMi: Double { return self / 1609.34 }
    private var toKm: Double { return self / 1_000.0 }

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

extension Double { //Volume Rate
    private var m3PerS: Double { return self }
    
    private var m3PerHr: Double { return self / 3600 }
    private var m3PerMin: Double { return self / 60 }
    private var literPerS: Double { return self / 1000 }
    private var literPerMin: Double { return self / 60_000 }
    private var literPerHr: Double { return self / 3_600_000 }
    private var gallonPerS: Double { return self * 0.003786 }
    private var gallonPerMin: Double { return self * (0.003786 / 60) }
    private var gallonPerHr: Double { return self * (0.003786 / 3600) }
    private var ft3PerS: Double { return self / 35.3147 }
    private var ft3PerMin: Double { return self / 2118.882}
    private var ft3PerHr: Double { return self / 127132.92}
    
    private var toM3PerHr: Double { return self * 3600 }
    private var toM3PerMin: Double { return self * 60 }
    private var toLiterPerS: Double { return self * 1000 }
    private var toLiterPerMin: Double { return self * 60_000 }
    private var toLiterPerHr: Double { return self * 3_600_000 }
    private var toGallonPerS: Double { return self / 0.003786 }
    private var toGallonPerMin: Double { return self / (0.003786 / 60) }
    private var toGallonPerHr: Double { return self / (0.003786 / 3600) }
    private var toFt3PerS: Double { return self * 35.3147 }
    private var toFt3PerMin: Double { return self * 2118.882 }
    private var toFt3PerHr: Double { return self * 127132.92 }

}

extension Double { //Viscosity
    private var PaS: Double { return self }
    
    private var NSPerM2: Double { return self }
    private var poise: Double { return self / 10 }
    private var cPoise: Double { return self / 1000 }
    private var lbSPerFt2: Double { return self * 47.8803 }
    private var lbSPerIn2: Double { return self * 6894.8 }
    
    private var toNSPerM2: Double { return self }
    private var toPoise: Double { return self * 10 }
    private var toCPoise: Double { return self * 1000 }
    private var toLbSPerFt2: Double { return self / 47.8803 }
    private var toLbSPerIn2: Double { return self / 6894.8 }
}

extension Double { //Speed
    private var mPerS: Double { return self }
    
    private var kmPerH: Double { return self / 3.6 }
    private var ftPerS: Double { return self * 0.3048 }
    
    private var toKmPerH: Double { return self * 3.6 }
    private var toFtPerS: Double { return self / 0.3048 }
}

extension Double { //Heat Capacity
    private var JPerKgC: Double { return self }
    
    private var JPerKgK: Double { return self }
    private var btuPerLbmR: Double { return self * 4186.8 }
    
    private var toJPerKgK: Double { return self }
    private var toBtuPerLbmR: Double { return self * 4186.8 }
}

extension Double { //Thermal Conductivity
    private var WPerMC: Double { return self }
    
    private var WPerMK: Double { return self }
    private var calPerMHrK: Double { return self * 0.001163 }
    private var btuPerFtHrR: Double { return self * 1.731 }
    
    private var toWPerMK: Double { return self }
    private var toCalPerMHrK: Double { return self / 0.001163 }
    private var toBtuPerFtHrR: Double { return self / 1.731 }
}

extension Double { //Power Per Length
    private var WPerM: Double { return self }
    
    private var calPerMHr: Double { return self * 860.00955566 }
    private var btuPerFtHr: Double { return self * 1.0402268658 }
    
    private var toCalPerMHr: Double { return self / 860.00955566 }
    private var toBtuPerFtHr: Double { return self / 1.0402268658 }
}

extension Double { //Volume
    private var m3: Double { return self }
    
    private var cm3: Double { return self }
    private var L: Double { return self / 1000 }
    private var ft3: Double { return self / 35.3147 }
    private var mi3: Double { return self * pow(1609.34, 3.0) }
    private var gallon: Double { return self / 264.172 }
    private var barrel: Double { return self / 6.28977 }

    private var toCm3: Double { return self }
    private var toL: Double { return self * 1000 }
    private var toFt3: Double { return self * 35.3147}
    private var toMi3: Double { return self / pow(1609.34, 3.0)}
    private var toGallon: Double { return self * 264.172}
    private var toBarrel: Double { return self * 6.28977}

}

