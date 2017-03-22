import Foundation
import UIKit

public protocol FinishMovingDelegate {
    func didFinishMoving()
}

public class ConfigurationView: UIView, FinishMovingDelegate {
    
    var mainPoints: [PointView] = []
    
    let margin:CGFloat = 0
    
    var colors: [UIColor] = []
    
    var iterationsView: IterationsView?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        iterationsView = IterationsView()
        iterationsView?.frame.size = CGSize(width: frame.width, height: 26.0)
        iterationsView?.frame.origin = CGPoint(x: 0.0, y: frame.height - 45.0)
        iterationsView?.setupButtons()
        
        self.addSubview(iterationsView!)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setNumberOfPoints(_ count: Int) {
        if (count < 2) { return }
        
        mainPoints.removeAll()
        
        let begin = self.frame.width * margin
        let end = self.frame.width - begin
        
        let step = (end - begin)/CGFloat(count - 1)
        
        colors = Colors.generateColors(numberOfColors: count + count - 1)
        
        for i in 0..<count {
            let centerX = begin + step * CGFloat(i)
            let centerY:CGFloat = 80.0
            let view = PointView(center: CGPoint(x: centerX, y: centerY), color: colors[i*2])
            mainPoints.append(view)
            self.addSubview(view)
        }
        
        mainPoints[1].center.y -= 50
        
        setNeedsDisplay()
        self.superview?.setNeedsDisplay()
    }
    
    public func didFinishMoving() {
        (superview as? FinishMovingDelegate)?.didFinishMoving()
    }
    
    
    override public func draw(_ rect: CGRect) {
        
        if (mainPoints.isEmpty) { return }
        
        for i in 1..<mainPoints.count {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: mainPoints[i-1].center)
            bezierPath.addLine(to: mainPoints[i].center)
            bezierPath.lineWidth = 2.0
            colors[i*2 - 1].set()
            bezierPath.stroke()
        }
    }
    
    func setPosition(x: CGFloat, y: CGFloat, forPoint point: PointView) {
        point.center = CGPoint(x: x, y: y)
        self.setNeedsDisplay()
    }
    
    
    
}
