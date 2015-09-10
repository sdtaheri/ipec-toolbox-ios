//
//  PDFRenderer.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/7/1.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit
import CoreText

private struct Constants {
    static let Width: CGFloat = 612
    static let Height: CGFloat = 792
    
    static let LogoWidth: CGFloat = 101
    static let LogoHeight: CGFloat = 51
    
    static let ImageWidth: CGFloat = 330
    static let ImageHeight: CGFloat = 220
}

class PDFRenderer: NSObject {

    class func drawPDF(pdfFileName: String, title: String, labels: [String], results: [String: (Double,String,Int)]?, dynamicResults: [String]?) {
        
        // Create the PDF context using the default page size of 612 x 792.
        UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
        // Mark the beginning of a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, Constants.Width, Constants.Height), nil);
        
        let borderFrame = CGRect(x: 5, y: 5, width: Constants.Width - 10, height: Constants.Height - 10)
        UIColor.blackColor().setStroke()
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2);

        let bezierPath = UIBezierPath(roundedRect: borderFrame, cornerRadius: 5)
        bezierPath.stroke()
        
        let logo = UIImage(named: "logo")!
        let frame = CGRect(x: 20, y: 20, width: Constants.LogoWidth, height: Constants.LogoHeight);
        drawImage(logo, inRect: frame)
        
        if let formulaImage = UIImage(named: "\(title) 1") {
            let formulaImageFrame = CGRect(x: (Constants.Width - Constants.ImageWidth) / 2, y: 100, width: Constants.ImageWidth, height: Constants.ImageHeight)
            drawImage(formulaImage, inRect: formulaImageFrame)
        }
        
        if dynamicResults == nil {
            drawTableAt(CGPoint(x: 40, y: 120 + Constants.ImageHeight), rowHeight: results!.count > 10 ? (Constants.Height - 140.0 - Constants.ImageHeight) / CGFloat(results!.count) : 44, columnWidth: (Constants.Width - 80) / 2, rowCount: results!.count, columnCount: 2, labels: labels, results: results, dynamicResults: dynamicResults)
        } else {
            drawTableAt(CGPoint(x: 40, y: 120), rowHeight: dynamicResults!.count > 10 ? (Constants.Height - 140.0 - Constants.ImageHeight) / CGFloat(dynamicResults!.count) : 44, columnWidth: (Constants.Width - 80) / 2, rowCount: dynamicResults!.count, columnCount: 2, labels: labels, results: results, dynamicResults: dynamicResults)
        }
        
        drawTitle(title)
        
        
        // Close the PDF context and write the contents out.
        UIGraphicsEndPDFContext();

    }
    
    private class func drawText(text: String, inFrame frame: CGRect, fontName: String, fontSize: CGFloat, centerAligned: Bool) {
        
        let textToDraw = text
        let stringRef = textToDraw as CFStringRef
        
        // Prepare the text using a Core Text Framesetter.
        
        let currentText = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
        CFAttributedStringReplaceString (currentText, CFRangeMake(0, 0), stringRef);
        
        let ctFont = CTFontCreateWithName(fontName, fontSize, nil) as CTFontRef
        
        CFAttributedStringSetAttribute(currentText, CFRangeMake(0, CFAttributedStringGetLength(currentText)),kCTFontAttributeName, ctFont);
        
        var alignment = centerAligned ? CTTextAlignment.Center : CTTextAlignment.Left
        let alignmentSetting = [CTParagraphStyleSetting(spec: .Alignment, valueSize: Int(sizeofValue(alignment)), value: &alignment)]
        let paragraphStyle = CTParagraphStyleCreate(alignmentSetting, 1)
        
        CFAttributedStringSetAttribute(currentText, CFRangeMake(0, CFAttributedStringGetLength(currentText)), kCTParagraphStyleAttributeName, paragraphStyle)
        
        let framesetter = CTFramesetterCreateWithAttributedString(currentText)
        
        let frameRect = frame
        let framePath = CGPathCreateMutable()
        CGPathAddRect(framePath, nil, frameRect);
        
        // Get the frame that will do the rendering.
        let currentRange = CFRangeMake(0, 0);
        let frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil);
        
        // Get the graphics context.
        
        if let currentContext = UIGraphicsGetCurrentContext() {
            // Put the text matrix into a known state. This ensures
            // that no old scaling factors are left in place.
            CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
            
            // Core Text draws from the bottom-left corner up, so flip
            // the current transform prior to drawing.
            CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2 + frameRect.size.height);
            CGContextScaleCTM(currentContext, 1.0, -1.0);
            
            // Draw the frame.
            CTFrameDraw(frameRef, currentContext);
            
            CGContextScaleCTM(currentContext, 1.0, -1.0);
            CGContextTranslateCTM(currentContext, 0, -frameRect.origin.y*2 - frameRect.size.height);
        }
    }
    
    private class func drawTitle(title: String) {
        let font = UIFont.boldSystemFontOfSize(17)
        drawText(title, inFrame: CGRect(x: 0, y: 75, width: Constants.Width, height: 50), fontName: font.fontName, fontSize: font.pointSize, centerAligned: true)
    }
    
    private class func drawImage(image: UIImage, inRect rect: CGRect) {
        image.drawInRect(rect)
    }
    
    private class func drawLineFromPoint(from: CGPoint, to: CGPoint) {
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 2.0);
        
        let uiColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3)
        let color = uiColor.CGColor as CGColorRef
        
        CGContextSetStrokeColorWithColor(context, color);
        
        
        CGContextMoveToPoint(context, from.x, from.y);
        CGContextAddLineToPoint(context, to.x, to.y);
        
        CGContextStrokePath(context);
    }
    
    private class func drawTableAt(origin: CGPoint, rowHeight: CGFloat, columnWidth: CGFloat, rowCount: Int, columnCount: Int, labels: [String], results: [String: (Double,String,Int)]?, dynamicResults: [String]?) {
        for i in 0...rowCount {
            let newOrigin = origin.y + rowHeight * CGFloat(i)
            
            let from = CGPointMake(origin.x, newOrigin);
            let to = CGPointMake(origin.x + (CGFloat(columnCount) * columnWidth), newOrigin);
            
            if i < labels.count {
                
                if i % 2 != 0 {
                    let frame = CGRect(x: origin.x, y: newOrigin, width: (CGFloat(columnCount) * columnWidth), height: rowHeight)
                    UIColor.groupTableViewBackgroundColor().setFill()
                    CGContextFillRect(UIGraphicsGetCurrentContext(), frame)
                }
                
                let font = UIFont.systemFontOfSize(14)
                
                let labelFrame = CGRectMake(from.x + 20, from.y + (rowHeight - 20)/2, columnWidth * 2, 20)
                drawText(labels[i], inFrame: labelFrame, fontName: font.fontName, fontSize: font.pointSize, centerAligned: false)
                
                if let resultValue = results?[labels[i]] {
                    var result = resultValue.0.doubleToStringWithThousandSeparator()!
                    
                    if let units = StringConstants.Units[resultValue.1] {
                        result = result + " " + units[resultValue.2]
                    }
                    
                    let resultFrame = CGRect(x: from.x + 1.5 * columnWidth, y: from.y + (rowHeight - 20)/2, width: columnWidth * 2, height: 20)
                    drawText(result, inFrame: resultFrame, fontName: font.fontName, fontSize: font.pointSize, centerAligned: false)
                } else if dynamicResults != nil {
                    let result = dynamicResults![i]
                    
                    let resultFrame = CGRect(x: from.x + 1.5 * columnWidth, y: from.y + (rowHeight - 20)/2, width: columnWidth * 2, height: 20)
                    drawText(result, inFrame: resultFrame, fontName: font.fontName, fontSize: font.pointSize, centerAligned: false)
                }
                
            }

            drawLineFromPoint(from, to: to)
        }
    }
}
