//
//  Calculations.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

struct MultipleChoiceItems {
    static let Dictionary = ["Pipeline Submerged Weight"+"Pipeline Condition" : ["Installation", "Hydrotest", "Operation (Marine Growth Present)", "Operation (Without Marine Growth)"]]
}

class Calculations: NSObject {
    
    //Output means:["Output Title": (Value, Unit Type , Unit Index)]
    
    class func dewPointTemperature(#airTemperature: Double, relativeHumidity: Double, airPressure: Double) -> [String: (Double,String,Int)] {
        
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
        
        return ["Saturated Water Vapor Pressure": (P_s,"Pressure",0), "Dew Point Temperature": (T_dp,"Temperature",0), "Dew Point Difference" : (T_diff,"Temperature",0), "Partial Pressure of Water": (P_H2O,"Pressure",0), "Partial Pressure of Dry Air": (P_a,"Pressure",0), "Wet Air Molar Density": (n_air,"Molar Density",0), "Dry Air Density": (Ro_air,"Density",0), "Vapor Density": (Ro_v,"Density",0), "Mole Fraction, Volume Mixing Ratio of Water": (x_H2O,"Fraction",0), "Specific Humidity (Mass Mixing Ratio in Wet Air)": (q,"Fraction",0), "Mass Mixing Ratio in Dry Air": (mmv,"Fraction",0), "Mass Concentration of Water": (c_H2O,"Density",4), "Molecular Concentration of Water": (M_H2O,"Inverse Volume",0)]
    }
    
    class func pipeLineSubmergedWeight(
        steelPipeOutsideDiameter OD_s: Double,
        pipeWallThickness t_p: Double,
        corrosionAllowance CA: Double,
        corrosionCoatingThickness t_corr: Double,
        concreteCoatingThickness t_conc: Double,
        var marineGrowthThickness t_mgt: Double,
        steelDensity ro_s: Double,
        productDensity ro_f: Double,
        corrosionCoatingDensity ro_corr: Double,
        concreteCoatingDensity ro_conc: Double,
        seaWaterDensity ro_w: Double,
        marineGrowthDensity ro_mgt: Double,
        fieldJointDensity ro_joint: Double,
        jointLenght L_joint: Double,
        corrosionCoatingCutbackLength L_corr: Double,
        concreteCoatingCutbackLength L_conc: Double,
        pipeLineCondition PC: String
        ) -> [String: (Double,String,Int)] {
            
            t_mgt = (PC == "Operation (Marine Growth Present)") ? t_mgt : 0
            
            var ro_p: Double = 0
            switch PC {
                case "Installation": ro_p = 0
                case "Hydrotest": ro_p = ro_w
                default: ro_p = ro_f
            }
            
            var t_CA: Double = 0
            switch PC {
                case "Operation (Marine Growth Present)", "Operation (Without Marine Growth)": t_CA = CA * 0.5
                default: t_CA = 0
            }
            
            let g = 9.78
            
            let OD = OD_s + 2 * (t_corr + t_conc + t_mgt)
            
            let ID = OD_s - 2 * (t_p - t_CA)
            
            let A_i = M_PI_4 * pow(ID, 2.0)
            
            let CSA_s = M_PI_4 * (pow(OD_s, 2.0) - pow(ID, 2.0))
            
            let CSA_corr = M_PI_4 * (pow(OD_s + 2 * t_corr, 2.0) - pow(OD_s, 2.0))
            
            let CSA_conc = M_PI_4 * (pow(OD_s + 2 * t_corr + 2 * t_conc, 2.0) - pow(OD_s + 2 * t_corr, 2.0))
            
            let CSA_mgt = M_PI_4 * (pow(OD_s + 2 * t_corr + 2 * t_conc + 2 * t_mgt, 2.0) - pow(OD_s + 2 * t_corr + 2 * t_conc, 2.0))
            
            let m_s = ro_s * A_i
            
            let m_corr = ro_corr * CSA_corr
            
            let m_conc = ro_conc * CSA_conc
            
            let m_mgt = ro_mgt * CSA_mgt
            
            let m_joint_corr = CSA_corr * ro_joint
            
            let m_joint_conc = CSA_conc * ro_joint
            
            let F_b = M_PI_4 * pow(OD, 2.0) * ro_w * g
            
            let m_dry = (m_s * L_joint + m_corr * (L_joint - 2 * L_corr) + m_conc * (L_joint - 2 * L_conc) + m_mgt * L_joint + m_joint_corr * L_corr + m_joint_conc * L_conc) / L_joint
            
            let W_sub = m_dry * g - F_b
            let W_dry = m_dry * g
    
            return ["Pipeline Submerged Weight":(W_sub,"Force Per Length",0), "Pipeline Dry Weight":(W_dry,"Force Per Length",0)]
    }
    
}
