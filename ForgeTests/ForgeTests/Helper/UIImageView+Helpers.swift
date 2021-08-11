//
//  UIImageView+Helpers.swift
//  AiMediaKit
//
//  Created by edvardzeng on 2020/7/15.
//  Copyright © 2020 tme. All rights reserved.
//

import UIKit

public extension UIImage {
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
    
    // need ios > 10
//    func imageWith(newSize: CGSize) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: newSize)
//        let image = renderer.image { _ in
//            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
//        }
//        return image.withRenderingMode(self.renderingMode)
//    }
    
    
    // MARK: - Resize methods
    
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        
        switch contentMode {
        case .contentFill:
            return resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    
    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

//public func creatSolidColorUIImage(color:UIColor, width: Int = 1, height: Int = 1) -> UIImage{
//    /**
//     创建一个 1x1 的纯色图片
//     */
//    let rect = CGRect(x:0,y:0,width:width,height:height)
//    UIGraphicsBeginImageContext(rect.size)
//    let context = UIGraphicsGetCurrentContext()
//    
//    context?.setFillColor(color.cgColor)
//    context!.fill(rect)
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return image!
//}
