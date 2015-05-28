//
//  Calculations.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class Calculations: NSObject {
    
    class func dewPointTemperature(airTemperature: Double, relativeHumidity: Double, airPressure: Double) -> [String: Double]? {
        
        let N_A = 6.022 * pow(10.0, 23.0)
        let R = 8.314
        let M_H2O = 18.02
        let M_dry = 28.96
        
        let RH = relativeHumidity / 100.0
        
        let a = -3.584 * pow(10.0, -5) * airTemperature + 6.111
        
        let b = -0.004699 * airTemperature + 17.62
        
        let c = -0.06541 * airTemperature + 242.7
        
        let P_s = 100 * a * exp((b * airTemperature) / (c + airTemperature))
        
        let gamma = log(RH * exp((b * airTemperature) / (c + airTemperature)))
        
        let T_dp = (c * gamma) / (b - gamma)
        
        let T_diff = airTemperature - T_dp
        
        let n_air = airPressure / (R * (airTemperature + 273.15))
        
        let P_H2O = RH * P_s
        
        let P_a = airPressure - P_H2O
        
        let Ro_air = 0.001 * ((P_a * M_dry) / (R * (airTemperature + 273.15)))
        
        let Ro_v = 0.001 * ((P_H2O * M_H2O) / (R * (airTemperature + 273.15)))
        
        let x_H2O = P_H2O / airPressure
        
        let q = (x_H2O * M_H2O) / (x_H2O * M_H2O + (1 - x_H2O) * M_dry)
        
        let mmv = q / (1-q)
        
        let c_H2O = x_H2O * n_air * M_H2O
        
        let m_H2O = x_H2O * n_air * N_A * pow(10.0, -6)
        
        return ["Saturated Water Vapor Pressure": P_s, "Dew Point Temperature": T_dp, "Dew Point Difference" : T_diff, "Partial Pressure of Water": P_H2O, "Partial Pressure of Dry Air": P_a, "Wet Air Molar Density": n_air, "Dry Air Density": Ro_air, "Vapor Density": Ro_v, "Mole Fraction, Volume Mixing Ratio of Water": x_H2O, "Specific Humidity (Mass Mixing Ratio in Wet Air)": q, "Mass Mixing Ratio in Dry Air": mmv, "Mass Concentration of Water": c_H2O, "Molecular Concentration of Water": M_H2O]
    }
    
}
