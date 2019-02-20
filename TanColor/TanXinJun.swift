//
//  TanXinJun.swift
//  TanColor
//
//  Created by 谭新均 on 2019/2/20.
//  Copyright © 2019 谭新均. All rights reserved.
//

import Foundation



//属性,方法和类必须使用public或open来修饰，这样他们才能调用我写的方法
open class TanXinJun: NSObject {
    
    ///得到名字
   public func getMyInfo(url:String){
        let ul = URL(string: url)
    print("您的网址是:\(String(describing: ul))")
    }
    
}





