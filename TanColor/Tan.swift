//  Created by 谭新均 on 2019/2/13.
//  Copyright © 2019 谭新均. All rights reserved.

import UIKit

//属性,方法和类必须使用public或open来修饰，这样他们才能调用我写的方法
 open class Tan: NSObject {
    
    ///得到名字
    public func getName()-> String{
        return "你成功调用了方法--谭新均"
    }
    
    ///得到颜色
    public func getMyColor()-> UIColor{
        return UIColor.orange
    }
    
}



