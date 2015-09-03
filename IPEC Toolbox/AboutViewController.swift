//
//  AboutViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/23.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var ipecLogo: UIImageView!
    @IBOutlet weak var ipecTextView: UITextView! {
        didSet {
            ipecTextView.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ipecTextView.scrollRangeToVisible(NSMakeRange(0, 1))
        
        let attributedString = NSMutableAttributedString(string: ipecTextView.text)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline), range: NSMakeRange(0, attributedString.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        let ipecURL = NSAttributedString(string: "www.ipecgroup.net\n\n\n", attributes: [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline), NSParagraphStyleAttributeName:paragraphStyle])
        attributedString.appendAttributedString(ipecURL)
        
        var redcubeAttributedString = NSMutableAttributedString(string: "Developed by:\n")
        redcubeAttributedString.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote), range: NSMakeRange(0, redcubeAttributedString.length))

        redcubeAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, redcubeAttributedString.length))
        
        let textAttachment = NSTextAttachment()
        let image = UIImage(named: "redcube-logo")!
        let scale = ipecLogo.image!.size.height / image.size.height;
        
        let size = CGSize(width: 3.3 * ipecLogo.frame.size.height, height: ipecLogo.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        textAttachment.image = scaledImage
        var attrStringWithImage = NSAttributedString(attachment: textAttachment)
        let temp = NSMutableAttributedString(attributedString: attrStringWithImage)
        temp.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, temp.length))

        redcubeAttributedString.appendAttributedString(temp)
        let redcubeURL = NSAttributedString(string: "\nwww.redcube.ir", attributes: [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote), NSParagraphStyleAttributeName:paragraphStyle])
        redcubeAttributedString.appendAttributedString(redcubeURL)
        attributedString.appendAttributedString(redcubeAttributedString)
       
        ipecTextView.attributedText = attributedString;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
