//: Playground - noun: a place where people can play

import UIKit

//let常量  var变量
var str = "Hello, playground"
var str1 = "123"
var str2 = "456"

//字符串拼接
var result = str1 + str2

//可以在一行中声明多个常量或者多个变量，用逗号隔开
var a = 0.0, b = 0.0, c = 0.0

var button = UIButton()
button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
button.backgroundColor = UIColor.red
button.layer.cornerRadius = 10


var age = 10

//整型转字符串
var ageStr = String(age)
var ageStr2 = "\(age)"

var hand = 2
var str3 = "I have \(hand) hand, \(age) years old"

let 姓名 = "qwert"


姓名 + String(age)


//数据类型
//指定常量/变量的数据类型  (一般来说没有必要指定类型，Swift会自动推断类型)
let age1: Int = 10

//整数  Swift提供了8、16、32、64位有符号和无符号的整数
UInt8.max
UInt8.min
Int8.min
//Int\UInt的长度和当前系统平台一样




//浮点型  Doublt/Float
let f = 3.14
let ff: Float = 3.14

//十进制 有指数
let d1 = 12.5

//十进制 没有指数
let d2 = 0.125e2

//十六进制 一定要有指数
let d3 = 0xc.8p0
let d4 = 0xc.8p1




//数字格式 额外增加下划线增加可读性
var money = 1000000
money = 100_0000
money = 1_000_000


//类型别名
typealias MyInt = Int


//Bool  只有true才为真


//运算符

//求余结果的正负跟%左边数值的正负一样
9 % 4
-9 % 4
9 % -4



//范围运算符  ..<   ...

for i in 0..<5 {
    print(i)
}

for i in 0...5 {
    print(i)
}

//溢出运算符  &+   &-  &*   &/   &%
let x = UInt8.max
let y = x &+ 1




//元祖类型
var point = (x: 10, y: 20)
point.x = 30
point.y
point.0
point.1

print(point)

//可以省略元素名称
point = (100, 300)

var persion = (name: "jack")
var persion2: (Int, String) = (age: 20, name: "james")


for i in 0...5 {
    print("****\(i)")
}

//括号里面用不到i可以用_代替
for _ in 0...5 {
    print("******")
}

/**
 *  switch 里面可以跟字符串,case结尾不需要break,
 *  每个case后面都必须要有可执行语句
 *  1个case后面可以填写多个匹配条件，条件之间用逗号隔开
 *
 **/
let grade = "D"
switch grade {
    case "A":
        print("优秀")
    case "B":
        print("良好")
    case "C":
        print("中等")
    case "D", "E":
        print("差")
    default:
        print("未知等级")
}

//case后面可以填写一个范围作为匹配条件
let scroe = 95
switch scroe {
    case 90...1000:
        print("优秀")
    case 60...89:
        print("及格")
    default:
        print("不及格")
}

//case还可以用来匹配元祖
let point2 = (1, 1)
switch point2 {
    case (0, 0):
        print("这个点在原点上")
    case (_, 0):
        print("这个点在x轴上")
    case (0, _):
        print("这个点在y轴上")
    case (-2...2, -2...2):
        print("这个点在矩形框内")
    default:
        print("")
}

//case的数值绑定：在case匹配的同时，可以将switch中的值绑定给一个特定的常量或者变量，以便在case后面的语句中使用
let point3 = (10, 0)
switch point3 {
case (let x, 0):
    print("这个点在x轴上，x值是\(x)")
case let (x, y):
    print("这个点的x值是\(x), y值是\(y)")
}

//switch语句可以使用where来增加判断的条件
//case let (x, y) where x == y :

//fallthrough：执行完当前case后，会接着执行fallthrough后面的case或者default语句
//fallthrough后面的case不能定义常量或者变量
let num = 20
var str4 = "\(num)是个"
switch num {
    case 0...50:
        str4 += "0~50之间的"
        fallthrough
    default:
        str4 += "整数"
}
print(str4)



//标签  指定退出哪个循环

out :
for _ in 1...2 {
    
    for _ in 1...3 {
        print("做俯卧撑")
        break out
    }
    
    print("休息一次")
}





//函数
/*
     func 函数名(形参列表) -> 返回值类型 {
        函数体
     }
 */
func sum(num1: Int, num2: Int) -> Int {
    return num1 + num2
}

//无返回值
func printStart() {
    print("**************")
}
printStart()

//返回元祖类型
func getPoint() -> (Int, Int) {
    return (10, 20)
}

//默认参数
func addStudent(name: String, age: Int, no: Int = 20) {
    print("number = \(no)")
}

addStudent(name: "jim", age: 10)

//输入输出参数
func swap(num1: inout Int, num2: inout Int) {
    let temp = num1
    num1 = num2
    num2 = temp
}
var aa = 10
var bb = 20
swap(&aa, &bb)
print("aa = \(aa) bb = \(bb)")

var arr: Array<String>
var arr2: [String]





