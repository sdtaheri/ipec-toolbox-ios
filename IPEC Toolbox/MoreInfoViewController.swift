//
//  MoreInfoViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/29.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {

    var formulaTitle: String?
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLayoutSubviews() {
        visualEffectView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(visualEffectView, atIndex: 0)
        
        switch formulaTitle! {
        case "Pipeline Submerged Weight":
            textView.text = "This module calculates weight of a pipeline joint with specified layers of coating. This calculation can be used for both onshore and offshore pipelines. The reduced weight due to the Archimedes (buoyancy) force is considered and both dry and submerged weight values are calculated. Also if the density of the fluid in pipeline is known, both empty and full line weights will be available. It is assumed that is some cutback for corrosion and concrete coatings where field joint is used."
            
        case "Maximum Allowable Working Pressure":
            
            let attributedStringParagraphStyle = NSMutableParagraphStyle()
            attributedStringParagraphStyle.paragraphSpacingBefore = 4.0
            
            let attributedStringParagraphStyleOne = NSMutableParagraphStyle()
            attributedStringParagraphStyleOne.firstLineHeadIndent = 20.0
            attributedStringParagraphStyleOne.paragraphSpacingBefore = 4.0
            
            let attributedStringParagraphStyleTwo = NSMutableParagraphStyle()
            attributedStringParagraphStyleTwo.firstLineHeadIndent = 20.0
            attributedStringParagraphStyleTwo.headIndent = 29.0
            attributedStringParagraphStyleTwo.paragraphSpacingBefore = 4.0
            
            let attributedString = NSMutableAttributedString(string: "This module gives the maximum internal pressure at which the weakest element of a vessel is loaded to the ultimate permissible point, when the vessel:\n- is not corroded (new)\n- the temperature does not affect its strength (room temperature) (cold) and the other conditions (wind load, external pressure, hydrostatic pressure, etc.) need not be taken into consideration.\n")
            
            attributedString.addAttribute(NSFontAttributeName, value:UIFont.preferredFontForTextStyle(UIFontTextStyleBody), range:NSMakeRange(0,370))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,151))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleOne, range:NSMakeRange(151,24))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyleTwo, range:NSMakeRange(175,195))
            
            textView.attributedText = attributedString
            
        case "Temperature Drop Across Pipe Wall":
            textView.text = "This module calculates the temperature across the pipe wall containing the temperatures of all coating interfaces. Knowing the temperature profile helps us to calculate the heat loss from the wall to the ambient and thus the temperature of working fluid along the pipeline will be known. In other application the temperature drop across the pipe wall helps to choose the appropriate coating for the pipeline."
            
        case "Pipe Wall Thickness":
            textView.text = "This module calculates the minimum required pipe/pipeline wall thickness. The pipeline wall thickness must resist the stresses caused by the internal pressure. Various stresses due to internal pressure are hoop stress, longitudinal stress and the radial stress. Normally the most critical stress is the hoop stress so that the pipe wall thickness should be evaluated from the hoop stress equation. \n\nIn addition to the pipeline characteristics and pressure effects, the location class must be specified according to the ASME Standards. Such additional parameter alongside with the type of pipeline product is used in calculating the required wall thickness."
            
        case "Pressure Drop for Fluid Flow in Pipelines":
            textView.text = "This module calculates the pressure drop for flow of a fluid through a pipeline. The fluid phase must be a liquid or gas. The calculation considers major losses due to friction and also the pressure drop due to change in elevation of pipeline inlet and outlet. For calculating the friction coefficient, the estimated absolute surface roughness must be specified."
            
        case "Chemical Dosing for Water Treatment":
            textView.text = "This module calculates the required pumping capacity for a dosing (injection) pump in water treatment operations. It is assumed that a specified chemical dosage must be provided for the main water stream. Knowing the water flow rate value in addition to the dosage, the flow rate of injection pump can be calculated."
            
        case "Pipeline Internal Volume":
            textView.text = "This module simply calculates internal volume of a circular pipeline."
            
        case "Dew Point Temperature":
            textView.text = "The main result from this module is the dew point temperature. However partial pressure of water and air, saturated water vapor pressure, etc. is calculated. Calculation of dew point temperature is required in many industrial applications such as pre-commissioning of pipelines. To avoid hydrate formation when the pipe is put into service and to attain the minimum H2O level, the pipeline is dried and brought to its dew point about -40°C before injection of commercial gas."
            
        case "Mean Flow Velocity":
            textView.text = "This module calculates the mean flow velocity of a fluid flowing inside a pipe/pipeline. It must be noticed that velocity of fluid particles are not equal at a pipe cross-section. However, it can be assumed that there is an average velocity value with respect to the flow."
            
        default: break
        }
        
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
}
