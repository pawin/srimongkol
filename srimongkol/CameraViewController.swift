//
//  CameraViewController.swift
//  srimongkol
//
//  Created by NiM Thitipariwat on 20/7/2562 BE.
//  Copyright © 2562 Srimongkol. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    private let WIDTH = UIScreen.main.bounds.width
    private let HEIGHT = UIScreen.main.bounds.height

    private let captureSession = AVCaptureSession()
    private var backFacingCamera: AVCaptureDevice?
    private var currentDevice: AVCaptureDevice?
    private let previewLayer = CALayer()
    private let lineShape = CAShapeLayer()
    
    private let queue = DispatchQueue(label: "srimongkol.camera.video.queue")
    private var center: CGPoint = CGPoint.zero
    
    private let label = UILabel()
    
    var colors = [
        UIColor(red: 0.97, green: 0.54, blue: 0.88, alpha: 1.00)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        center = CGPoint(x: WIDTH/2-15, y: WIDTH/2-15)
        
        setupUI()
        createUI()
        
        label.textAlignment = .center
        label.frame = CGRect(x: 20, y: 50, width: WIDTH-40, height: 40)
        self.view.addSubview(label)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        guard let baseAddr = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else {
            return
        }
        let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bimapInfo: CGBitmapInfo = [
            .byteOrder32Little,
            CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]
        
        guard let content = CGContext(data: baseAddr, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bimapInfo.rawValue) else {
            return
        }
        
        guard let cgImage = content.makeImage() else {
            return
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.previewLayer.contents = cgImage
            if let color = self.previewLayer.pickColor(at: self.center) {
                self.view.backgroundColor = color
                self.lineShape.strokeColor = color.cgColor

                var matched = 0
                for c in self.colors {
//                    if c.isEqualToColor(color: color, withTolerance: 0.25) {
                    if c.colorDistance(from: color) < 0.5 {
                        matched += 1
                    } else {
                        matched -= 1
                    }
                    
//                    print("colorDistance \(c.colorDistance(from: color))")
                }
                
                if matched > 0 {
                    self.label.text = "OK"
                } else {
                    self.label.text = "X"
                }
            }
        }
        
    }

    func setupUI() {
        previewLayer.bounds = CGRect(x: 0, y: 0, width: WIDTH-30, height: WIDTH-30)
        previewLayer.position = view.center
        previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        previewLayer.masksToBounds = true
        previewLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)))
        view.layer.insertSublayer(previewLayer, at: 0)
        
        let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        lineShape.frame = CGRect.init(x: WIDTH/2-20, y:HEIGHT/2-20, width: 40, height: 40)
        lineShape.lineWidth = 5
        lineShape.strokeColor = UIColor.red.cgColor
        lineShape.path = linePath.cgPath
        lineShape.fillColor = UIColor.clear.cgColor
        self.view.layer.insertSublayer(lineShape, at: 1)
        
        let linePath1 = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 8, height: 8))
        let lineShape1 = CAShapeLayer()
        lineShape1.frame = CGRect.init(x: WIDTH/2-4, y:HEIGHT/2-4, width: 8, height: 8)
        lineShape1.path = linePath1.cgPath
        lineShape1.fillColor = UIColor.init(white: 0.7, alpha: 0.5).cgColor
        self.view.layer.insertSublayer(lineShape1, at: 1)
    }
    
    func createUI(){
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720        
        let devices = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices

        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                self.backFacingCamera = device
            }
        }

        self.currentDevice = self.backFacingCamera
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA)] as? [String : Any]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            if self.captureSession.canAddOutput(videoOutput) {
                self.captureSession.addOutput(videoOutput)
            }
            self.captureSession.addInput(captureDeviceInput)
        } catch {
            print(error)
            return
        }
        
        self.captureSession.startRunning()
    }
}

extension CALayer {
    
    func pickColor(at position: CGPoint) -> UIColor? {
        var pixel = [UInt8](repeatElement(0, count: 4))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.translateBy(x: -position.x, y: -position.y)
        render(in: context)
        
        return UIColor(red: CGFloat(pixel[0]) / 255.0,
                       green: CGFloat(pixel[1]) / 255.0,
                       blue: CGFloat(pixel[2]) / 255.0,
                       alpha: CGFloat(pixel[3]) / 255.0)
    }
}

extension UIColor{
    
    func isEqualToColor(color: UIColor, withTolerance tolerance: CGFloat = 0.0) -> Bool{
        
        var r1 : CGFloat = 0
        var g1 : CGFloat = 0
        var b1 : CGFloat = 0
        var a1 : CGFloat = 0
        var r2 : CGFloat = 0
        var g2 : CGFloat = 0
        var b2 : CGFloat = 0
        var a2 : CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = abs(r1 - r2)
        let g = abs(g1 - g2)
        let b = abs(b1 - b2)
//        let a = abs(a1 - a2)
        
        return
            r <= tolerance &&
            g <= tolerance &&
            b <= tolerance //&&
//            a <= tolerance
    }
    
    func colorDistance(from color:UIColor) -> CGFloat {
        
        var r1 : CGFloat = 0
        var g1 : CGFloat = 0
        var b1 : CGFloat = 0
        var a1 : CGFloat = 0
        var r2 : CGFloat = 0
        var g2 : CGFloat = 0
        var b2 : CGFloat = 0
        var a2 : CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let rmen:CGFloat = (r1 + r2)/2.0
        let r:CGFloat = r1 - r2
        let g:CGFloat = g1 - g2
        let b:CGFloat = b1 - b2
        let weghtR:CGFloat = 2.0 + rmen/256.0
        let weightG:CGFloat = 4.0
        let weightB = 2.0 + (255.0-rmen)/256.0
//        double rmean = ( c1.getRed() + c2.getRed() )/2;
//        int r = c1.getRed() - c2.getRed();
//        int g = c1.getGreen() - c2.getGreen();
//        int b = c1.getBlue() - c2.getBlue();
//        double weightR = 2 + rmean/256;
//        double weightG = 4.0;
//        double weightB = 2 + (255-rmean)/256;
//        return Math.sqrt(weightR*r*r + weightG*g*g + weightB*b*b);
        
        return sqrt(weghtR*r*r + weightG*g*g + weightB*b*b)
    }
}
