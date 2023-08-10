
import Foundation
import SwiftUI

// Property Wrapper 属性包装器
// 用来打包【计算属性】或【属性观察】的功能, 方便重复使用

// @Suffix("g") var fat: Double = .zero // fat 是储存的值,  $fat 是投射的属性

// State<Value> 用来储存喝观察一个 Vlue Type 的方法
// Binding<Value> 用来让某些值保持唯一
// Environment<Value> 用来在系统刚开始启动时设置某些变量


//👇这样定义打印的 card.balance 为 1000
func main2() {
    struct User {
        let name: String
        var creditCard: CreditCard //这样写的话其实是两个对象！！所以下面会打印出 1000！
    }
    
    struct CreditCard {
        var balance: Int
        var cardNumber: String
        
    }
    
    var card = CreditCard(balance: 1000, cardNumber: "88886666")
    var user = User(name: "Jane", creditCard: card)
    user.creditCard.balance -= 100
    print(user.creditCard.balance) //900
    print(card.balance) //1000
}



//👇这样定义打印的 card.balance 为 900
func main3() {
    struct User {
        let name: String
        @Binding var money: Int
    }
    
    struct CreditCard {
        var balance: Int
        var cardNumber: String
        
    }
    
    var card = CreditCard(balance: 1000, cardNumber: "88886666")
    var user = User(name: "Jane", money: Binding(
                                            get: { card.balance },
                                            set: { card.balance = $0 }
                                        )
                    )
    user.money -= 100
    print(user.money) //900
    print(card.balance) //900
}



struct ContentView2: View {
    @State private var name: String = ""
    @State private var password: String = ""
    
    func login(account: String, password: String) {
        // 在这里实现登录逻辑
        print("你好, 登录中...")
    }

    var body: some View {
        VStack(spacing: 15) {
            Text("👏欢迎登录")
            TextField("帐号", text: $name)
            TextField("帐号", text: $password)
            Button("登录") {
                login(account: name, password: password)
            }
        }
    }
}



struct ContentView3: View {
    @Environment(\.colorScheme) var colorScheme //读取系统的环境变量
    
    var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    
    var body: some View {
        Circle()
            .fill(isDarkMode ? Color.pink : Color.teal) // 根据深色模式
    }
}






