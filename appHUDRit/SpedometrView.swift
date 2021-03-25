//
//  SpedometrView.swift
//  HUDApp
//
//  Created by Maxorax on 24.03.2021.
//

import UIKit

@IBDesignable
class SpeedometrView: UIView {

   
 
    @IBInspectable var speed: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var mSys = "км" {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var radius: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    private var cir: Int = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {

        if rect.height >= rect.width {
         radius = rect.width/2 - 5
        } else {
            radius = rect.height/2 - 5
        }
  
        drawSpeedometr(in: rect)
        drawArrow(in: rect)
    }
    
    private func drawSpeedometr(in rect: CGRect){
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 145 * CGFloat.pi / 180 , endAngle:  35 * CGFloat.pi / 180, clockwise: true)
        
        let arrAngle = [145...175,-180...(-5),0...35]
        var count = 1
        var z = 10
        for i in arrAngle  {
            
            for j in i where j % 5 == 0 {
             z = 10
            count -= 1
            if count == 0 {
                z = 20
                count=10
                if cir > 5 {
                    cir = 0
                }
                drawText(in: rect, x: center.x + (radius - CGFloat(z)) * cos(CGFloat(j) * CGFloat.pi/180), y: center.y + (radius - CGFloat(z)) * sin(CGFloat(j) * CGFloat.pi/180))
                
                cir += 1
            }
            if count == 5 {
                z = 15
            }
            path.move(to:  CGPoint(x: center.x + (radius - CGFloat(z)) * cos(CGFloat(j) * CGFloat.pi/180), y: center.y + (radius - CGFloat(z)) * sin(CGFloat(j) * CGFloat.pi/180)))
            path.addLine(to: CGPoint(x: center.x + (radius + 1)  * cos(CGFloat(j) * CGFloat.pi/180), y: center.y + (radius + 1) * sin(CGFloat(j) * CGFloat.pi/180)))
        }
        }

        
        let color = UIColor.red
        color.setStroke()
        path.lineWidth = 2
        path.stroke()
    }
    
    private func drawArrow(in rect: CGRect){
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let path = UIBezierPath()
        path.move(to: center)
        path.addLine( to: CGPoint(x: center.x + (radius - 30) * cos( 2.51 + 0.0087 * speed) , y: center.y + (radius - 30) * sin(2.51 + 0.0087 * speed)))
        let color = UIColor.green
        color.setStroke()
        path.lineWidth = 2
        path.stroke()
    }
    
    private func drawText(in rect: CGRect, x: CGFloat, y: CGFloat){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
     
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: radius / 15),
            .foregroundColor: UIColor.black
        ]

        let myText = String(cir * 100)
        let attributedString = NSAttributedString(string: myText, attributes: attributes)

        let stringRect = CGRect(x: x - CGFloat(cir * 5) , y: y, width: rect.width / 2, height: rect.height / 2 )
        attributedString.draw(in: stringRect)

    }

}

