import UIKit
import Metal
import MetalPerformanceShaders

/*
 Since we can't use XCTest, we'll do a very primitive form of unit testing.
 
 You have to create the test classes and call each of the test cases by hand.
 Any output goes to stdout.
 As soon as something trips an assert, the app terminates.
 You need to run this app on a device.
 
 But even this primitive approach is good enough for making sure the compute
 kernels work properly etc.
 */

var device: MTLDevice!
var commandQueue: MTLCommandQueue!

@available(iOS 13.0, *)
class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        device = MTLCreateSystemDefaultDevice()
        if device == nil {
            print("Error: this device does not support Metal")
            return
        }
        
        guard MPSSupportsMTLDevice(device) else {
            print("Error: this device does not support Metal Performance Shaders")
            return
        }
        
        commandQueue = device.makeCommandQueue()
        
        // Wait a second for the app to finish loading before running the tests.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: runTests)
    }
    
    func test1(){
        // 测试对比输出精度的误差
        let arrayTests = ArrayTests()
        arrayTests.testArgmax()
        arrayTests.testArgsort()
        arrayTests.testGather()
        
        let basicConvTests = BasicConvolutionTests()
        basicConvTests.testCorrectness()
        let depthwiseConvTests = DepthwiseConvolutionTests()
        if #available(iOS 11.0, *) {
            depthwiseConvTests.testCorrectness(versusMPSDepthWise: true)
        } else {
            depthwiseConvTests.testCorrectness(versusMPSDepthWise: false)
        }
        depthwiseConvTests.testGroups()
    }
    
    
    func test2(){
        // 运行速度测试
        
        //    let myBasicConvTest = BasicConvolutionTests()
        //
        //    var st = Date()
        //    for _ in 0..<50{
        //        myBasicConvTest.testSpeed()
        //
        //    }
        //    var cost = Date().timeIntervalSince(st) * 1000
        //    print(String(format: "%.2f ms", cost/50.0))
        
        // coreml
        let img = UIImage(named: "test.png")
        let model = try! one_conv(configuration: .init())
        
        let st = Date()
        for i in 0..<50{
            let res = try! model.prediction(img: (img?.pixelBuffer(width: 480, height: 360)!)!)
        }
        let cost = Date().timeIntervalSince(st) * 1000
        print(String(format: "%.2f ms", cost/50.0))
        
    }
    
    
    @IBAction func runTests() {
        print("\n-----Running Tests-----")
        button.isEnabled = false
        

        
        
        print("All tests successful!")
        button.isEnabled = true
    }
}
