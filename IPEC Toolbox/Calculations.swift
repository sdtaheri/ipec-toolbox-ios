//
//  Calculations.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

struct MultipleChoiceItems {
    static let Dictionary = [
        "Pipeline Submerged Weight"+"Pipeline Condition" : ["Installation", "Hydrotest", "Operation (Marine Growth Present)", "Operation (Without Marine Growth)"],
        
        "Maximum Allowable Working Pressure"+"Joint Efficiency" : ["Type 1 - Fully Radiographed", "Type 1 - Spot Examined", "Type 1 - Not Examined", "Type 2 - Fully Radiographed", "Type 2 - Spot Examined", "Type 2 - Not Examined", "Type 3 - Not Examined", "Type 4 - Not Examined", "Type 5 - Not Examined", "Type 6 - Not Examined" ],
        
        "Pipe Wall Thickness"+"Location Class (For Human Occupancy)": ["Location Class 1, Division 1", "Location Class 1, Division 2", "Location Class 2", "Location Class 3", "Location Class 4"],
        "Pipe Wall Thickness"+"Pipeline Production": ["Gas", "Oil"]

    ]
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
    
    class func maximumAllowableWorkingPressure(jointEfficiency E: String, pipelineOutsideDiameter OD: Double, pipelineWallThickness t: Double, var yieldStress S_y: Double) -> [String: (Double,String,Int)] {
     
        S_y = S_y.convert(fromUnit: "Pa", toUnit: "psi", kind: "Pressure")!
        
        let E_numeric: Double
        
        switch E {
        
        case "Type 1 - Fully Radiographed": E_numeric = 1.0
        case "Type 1 - Spot Examined": E_numeric = 0.85
        case "Type 1 - Not Examined": E_numeric = 0.7
        case "Type 2 - Fully Radiographed": E_numeric = 0.9
        case "Type 2 - Spot Examined": E_numeric = 0.8
        case "Type 2 - Not Examined": E_numeric = 0.65
        case "Type 3 - Not Examined": E_numeric = 0.6
        case "Type 4 - Not Examined": E_numeric = 0.55
        case "Type 5 - Not Examined": E_numeric = 0.5
        case "Type 6 - Not Examined": E_numeric = 0.45

        default: E_numeric = 0.0
        }
        
        let R = OD / 2
        let P = (S_y * E_numeric * t) / (R - 0.4 * t)
        
        return ["Maximum Allowable Working Pressure":(P,"Pressure",4)]
    }
    
    class func temperatureDropAcrossPipewall(
        ambientFluidDensity ro_seawater: Double,
        ambientFluidHeatCapacity C_seawater: Double,
        ambientFluidThermalConductivity K_seawater: Double,
        ambientFluidVelocity v_current: Double,
        ambientFluidViscosity mu_seawater: Double,
        ambientTemperature T_ambient: Double,
        coatingThermalConductivity K_coat: Double,
        coatingThickness t_coat: Double,
        concreteThermalConductivity K_concrete: Double,
        concreteThickness t_concrete: Double,
        fluidTemperature T_fluid: Double,
        internalFluidDensity ro_fluid: Double,
        internalFluidHeatCapacity C_fluid: Double,
        internalFluidThermalConductivity K_fluid: Double,
        internalFluidViscosity mu_fluid: Double,
        internalFluidVolumetricFlowRate Q: Double,
        nominalOuterDiameter OD: Double,
        pipewallThickness t_steel: Double,
        pipelineBuriedHeight H_soil: Double,
        pipelineThermalConductivity K_steel: Double,
        soilThermalConductivity K_soil: Double) -> [String: (Double,String,Int)] {
        
            let ID = OD - 2 * t_steel
            
            let Pr_seawater = mu_seawater * C_seawater / K_seawater
            
            let Pr_inside = mu_fluid * C_fluid / K_fluid
            
            let v_fluid = Q / (M_PI_4 * pow(ID, 2.0) * ro_fluid)
            
            let Re_inside = ro_fluid * v_fluid * ID / mu_fluid
            
            let Nu_fluid: Double
            if Re_inside < 2300 {
                Nu_fluid = 3.66
            } else {
                Nu_fluid = 0.023 * pow(Re_inside, 0.8) * pow(Pr_inside, 0.3)
            }
            
            let h_inside = K_fluid * Nu_fluid / ID
            
            let OD_coated_concrete = OD + 2 * t_coat + 2 * t_concrete
            
            let D_2concrete: Double
            if H_soil > 0 {
                D_2concrete = OD_coated_concrete * (2 * H_soil / OD_coated_concrete + sqrt(pow(2 * H_soil / OD_coated_concrete, 2.0) - 1))
            } else {
                D_2concrete = 0
            }
            
            let t_soil_concrete: Double
            if H_soil > 0 {
                t_soil_concrete = 0.5 * (D_2concrete - OD_coated_concrete)
            } else {
                t_soil_concrete = 0
            }
            
            let Re_outside_concrete = (ro_seawater * v_current * OD_coated_concrete) / mu_seawater
            
            let C2, m2 : Double
            if Re_outside_concrete < 4 {
                C2 = 0.989
                m2 = 0.33
            } else if Re_outside_concrete < 40 {
                C2 = 0.911
                m2 = 0.385
            } else if Re_outside_concrete < 4000 {
                C2 = 0.683
                m2 = 0.466
            } else if Re_outside_concrete < 40_000 {
                C2 = 0.193
                m2 = 0.618
            } else if Re_outside_concrete < 400_000 {
                C2 = 0.027
                m2 = 0.805
            } else {
                C2 = 0
                m2 = 0
            }
            
            let Nu_concrete = C2 * pow(Re_outside_concrete, m2) * pow(Pr_seawater, 1/3.0)
            
            let h_outside_concrete = K_seawater * Nu_concrete / OD_coated_concrete
            
            let R_inside_film = 1 / (h_inside * M_PI * ID)
            
            let R_steel = (log(OD/ID)) / (2 * M_PI * K_steel)
            
            let R_coat = (log((OD + 2 * t_coat)/OD)) / (2 * M_PI * K_coat)
            
            let R_concrete = (log((OD + 2 * t_coat + 2 * t_concrete)/(OD + 2 * t_coat))) / (2 * M_PI * K_concrete)
            
            let R_soil_concrete = (log((OD + 2 * t_coat + 2 * t_concrete + 2 * t_soil_concrete)/(OD + 2 * t_coat + 2 * t_concrete))) / (2 * M_PI * K_soil)
            
            let R_outside_film_concrete = 1 / (h_outside_concrete * M_PI * (OD_coated_concrete + t_soil_concrete))
            
            let R_total_concrete = R_inside_film + R_steel + R_coat + R_concrete + R_outside_film_concrete
            
            let Q_concrete = (T_fluid - T_ambient) / R_total_concrete
            
            let T_concrete = T_ambient + (R_outside_film_concrete / R_total_concrete) * (T_fluid - T_ambient)
            
            let T_coating = t_concrete + (R_concrete / R_total_concrete) * (T_fluid - T_ambient)
            
            let T_steel = T_coating + (R_coat / R_total_concrete) * (T_fluid - T_ambient)
            
            let T_inside = T_steel + (R_steel / R_total_concrete) * (T_fluid - T_ambient)
            
            
        return ["Heat Loss Across Pipe Wall Per Unit Length":(Q_concrete,"Power Per Length",0), "Ambient Temperature":(T_ambient,"Temperature",0), "Concrete Outer Temperature":(T_concrete,"Temperature",0), "Coating Outer Temperature":(T_coating,"Temperature",0), "Steel Outer Temperature":(T_steel,"Temperature",0), "Pipe Inside Temperature":(T_inside,"Temperature",0), "Fluid Temperature":(T_fluid,"Temperature",0)]
    }
    
    class func pipeWallThickness(locationClass F: String, pipelineDesignPressure P: Double, pipelineOutsideDiameter OD: Double, pipelineProduction GO: String, specifiedMinimumYieldStress S_y: Double) -> [String: (Double,String,Int)] {
        
        let GO_numeric: Double?
        switch GO {
        case "Gas": GO_numeric = 1.0
        case "Oil": GO_numeric = 0.0
        default: GO_numeric = nil
        }
        
        let F_numeric: Double?
        switch F {
        case "Location Class 1, Division 1": F_numeric = 0.80
        case "Location Class 1, Division 2": F_numeric = 0.72
        case "Location Class 2": F_numeric = 0.60
        case "Location Class 3": F_numeric = 0.50
        case "Location Class 4": F_numeric = 0.40
        default: F_numeric = nil
        }
        
        if F_numeric != nil && GO_numeric != nil {
            let S_a = GO_numeric! * (S_y * F_numeric!) + (1 - GO_numeric!) * (S_y * 0.72)
            let t = (P * OD) / (2 * S_a) * 1000
            
            return ["Pipeline Wall Thickness": (t,"Length",2)]
        } else {
            return ["":(0,"",0)]
        }
    }
    
    class func pressureDropForFluidFlowInPipelines(fluidDensity ro: Double, fluidDynamicViscosity mu: Double, pipelineInletElevation L_i: Double, pipelineLength L_p: Double, pipelineOutletElevation L_o: Double, pipelineOutsideDiameter OD: Double, pipelineWallThickness t: Double, surfaceRoughness epsilon: Double, volumetricFlowRate Q: Double) -> [String: (Double,String,Int)] {
        
        let ID = OD - 2 * t
        
        let V = Q / (M_PI_4 * pow(ID, 2.0))
        
        let Re = (ro * V / mu) * ID
        
        var f_old = 0.25 * pow(log10(epsilon / (3.7 * ID) + 5.74 / pow(Re, 0.9)) , -2)
        var f_new = f_old
        
        do {
            f_old = f_new
            let RHS = -2 * log10(epsilon / (3.7 * ID) + 2.51 / (Re * sqrt(f_old)))
            f_new = 1 / pow(RHS, 2.0)

        } while fabs(f_new - f_old) > pow(10.0, -6.0)
        
        
        let f = f_new
        
        let g = 9.81
        
        let deltaH_m = f * (L_p / ID) * (pow(V, 2.0) / (2 * g) )
        
        let deltaH_z = L_o - L_i
        
        let deltaH_T = deltaH_m + deltaH_z
        
        let deltaP_T = ro * g * deltaH_T
        
        return ["Head Loss Due to Elevation": (deltaH_z,"Length",0), "Major Head Loss": (deltaH_m,"Length",0), "Total Head Loss": (deltaH_T,"Length",0), "Total Pressure Drop": (deltaP_T,"Pressure",0)]
    }
    
    class func inhibitorChemicalAndSeaDyeInjectionRate(inhibitorChemicalDensity r_ic: Double, inhibitorChemicalDosage d_ic: Double, pipelineLength L: Double, outerDiameter OD: Double, wallThickness WT: Double, pumpStationFlowRate Q: Double, coefficient N_v: Double, seaDyeDensity r_sd: Double, seaDyeDosage d_sd: Double) -> [String: (Double,String,Int)] {
    
        let d_ic_fraction = d_ic / 1_000_000.0
        let d_sd_fraction = d_sd / 1_000_000.0
        
        let ID = OD - 2 * WT
        let V = M_PI_4 * pow(ID, 2.0) * L
        let V_ic = N_v * d_ic_fraction * V
        let V_sd = N_v * d_sd_fraction * V
        let m_ic = r_ic * V_ic
        let m_sd = r_sd * V_sd
        let Q_ic = d_ic_fraction * Q
        let Q_sd = d_sd_fraction * Q
        
        return ["Inner Diameter": (ID, "Length", 0), "Pipeline Volume": (V, "Volume", 0), "Required Inhibitor Chemical Volume": (V_ic, "Volume", 0), "Required Sea Dye Volume": (V_sd, "Volume", 0), "Required Inhibitor Chemical Mass": (m_ic, "Mass", 0), "Required Sea Dye Mass": (m_sd, "Mass", 0), "Required Inhibitor Chemical Flow Rate": (Q_ic, "Volume Rate", 0), "Required Sea Dye Flow Rate": (Q_sd, "Volume Rate", 0)]
    }
    
    class func pipelineInternalVolume(pipelineLength L: Double, pipelineOutsideDiameter OD: Double, pipelineWallThickness t: Double) -> [String: (Double,String,Int)] {
        
        let ID = OD - 2 * t
        let V = M_PI_4 * L * pow(ID, 2.0)
        
        return ["Internal Volume of The Pipeline": (V,"Volume",0)]
    }
    
    class func meanFlowVelocity(pipelineOutsideDiameter OD: Double, pipelineWallThickness t: Double, volumetricFlowRate Q: Double) -> [String: (Double,String,Int)] {
        
        let ID = OD - 2 * t
        let V = Q / (M_PI_4 * pow(ID, 2.0))
        
        return ["Mean Flow Velocity": (V,"Speed",0)]
    }

    class func pigLaunchingAndReceivingTimePrediction(pipelineLength L: Double, pipelineOutsideDiameter OD: Double, pipelineWallThickness WT: Double, pumpStationFlowRate Q: Double, requiredExtraTimeToLaunchASinglePig t_L: Double, requiredExtraTimeToReceiveASinglePig t_R: Double, startTimeSinceReferenceDate t_start: Double, dynamicValues dynamicInputs: [Double]) -> [String: (Double,String,Int)] {
        
        let ID = OD - 2 * WT
        let V = M_PI_4 * pow(ID, 2.0) * L
        
        var T = [Double]()
        for i in 0 ..< dynamicInputs.count {
            let t_B = (dynamicInputs[i] / 100.0 * V) / Q
            T.append(t_B)
            
            T.append(t_L)
        }
        
        let t_total = (V * (dynamicInputs.reduce(0, combine: +) - dynamicInputs[0]) / 100.0) / Q
        T.append(t_total)
        
        for i in 1 ..< dynamicInputs.count {
            T.append(t_R)
            
            let t_B = (dynamicInputs[i] / 100.0 * V) / Q
            T.append(t_B)
        }
        T.append(t_R)
        
        var result = ["Operation Start Time": (t_start, "Fraction", 0)]
        for i in 0 ..< T.count {
            let index = i+1 < 10 ? "0\(i+1)" : "\(i+1)"
            result["Dynamic Output \(index)"] = (T[i],"Fraction",0)
        }
        
        return result
    }
    
}
