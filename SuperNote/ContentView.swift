import SwiftUI



struct ContentView: View {
    let food = ["汉堡", "沙拉", "披萨", "义大利麵", "鸡腿便当", "刀削麵", "火锅", "牛肉麵", "关东煮"]
    
    @State private var selectedFood: String? //存放选好的 food, 用 @State 来声明, 可以在数据变动时更新 UI，类似 useState~

    let customColor = Color(red: 0.28, green: 0.22, blue: 0.9, opacity: 1) //自定义颜色
    
    // 👇渲染 UI
    var body: some View { //some 表示不透明【类型】
        VStack(spacing: 10) {//垂直排列(类似 flex)
            Text("今天吃什么？")
                .font(.largeTitle)
                .bold()
                .padding(.all, 6.0)
            
            
            Image("hambuger")
                .resizable() // 🚀（调整器的位置很重要！因为每一行都会返回自己的 View）
                .aspectRatio(contentMode: .fit)
                .frame(width: 240.0, height: 240.0)
                
//            Image(systemName: "globe")//systemName 是使用系统内置的 icon
//                .imageScale(.large)
//                .foregroundColor(.accentColor)//换成强调色（蓝色）
            
            
            if(selectedFood != .none) {
                Text(selectedFood ?? "")//文字展示为 => selectedFood 食物名
                    .font(.system(size: 24))
                    .padding(.vertical, 10)
                    .bold()
					.foregroundColor(customColor)
                    .id(selectedFood) // 🔥设定了 id 后, Swift UI 就会明确转场的是不同的对象效果为淡入淡出
//                    .transition(.scale.combined(with: .slide)) //组合动画
                    .transition(.asymmetric( //🔥分别设置进场、离场动画的动画曲线(需要有设置 id，不然 Swift 无法识别）
                        insertion:
                            .opacity
                            .animation(.easeInOut(duration: 0.5).delay(0.2)),
                        removal:
                            .opacity.animation(
                            .easeInOut(duration: 0.4))))
            }
            
            // 🚀👇下面两种实现方式会产生不同的动画
            selectedFood != .none ? Color.pink : Color.blue //【运算值的方式】, 会被判断为【同一个元素 - 同一个 View】, 因此会变成补帧的【形变动画】
            
//            if selectedFood != .none { //【条件值的方式】, 会被判断为【不同的元素 - 不同的 View】, 就会发生【转场动画】,因为 if 语句会被包装成 EitherView
//                Color.pink
//            } else {
//                Color.blue
//            }
            
            
            // 👇用带 label 的 Button 可以调整按钮的样式
            Button(role: .none) {
                withAnimation { //👈这个加了后会只影响当前这个元素, 单独让它有动画, 可以设置有动画的时机
                    selectedFood = food.shuffled().filter { $0 != selectedFood }.first //shuffled() 利用原始数组返回一个新的数组，其中包含原始数组中的元素，但顺序是随机的； $0 ! 表示过滤掉跟当前一样的元素，随机抽取下一个非当前元素的元素
                }
            } label: {
                Text(selectedFood == .none ? "告诉我" : "手气不错")
                    .animation(.none, value: selectedFood) //删除文字的渐变动画（系统默认效果）
                    .foregroundColor(.white)
                    .frame(width: 180, height: 38, alignment: .center) // 改变按钮宽度
                    .transformEffect(.init(translationX: 0, y: 0)) //明确文字的位置（ 涉及到了 Swift 内置动画的原理, Swift 内置了转场动画跟位移动画, 避免让文字元素产生上下移动的效果, 相当于不让位置变化）
            }
                .buttonStyle(.borderedProminent)
                .cornerRadius(12)
                .padding(.bottom, +4)
            //                .background(customColor)
             
			
            Button(role: .none) {
                selectedFood = .none
            } label: {
                Text("重置")
                    .padding(/*@START_MENU_TOKEN@*/.all, 8.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50, alignment: .center) // 改变按钮宽度
            }
                .background(.black)
                .cornerRadius(12)

            
        }
        
            .frame(maxWidth: .infinity, maxHeight: .infinity)//背景无限延伸 （调整器的位置很重要！）
            .padding().opacity(0.8)
            .animation(.easeInOut(duration: 0.3), value: selectedFood) //⚡️这个动画要放在 VStack 身上，是因为要在 VStack 开始出现时就开始观察动画，动画的时间跟变化速率 、变化的对象（比如食物文字发生变化，就执行动画）
            .background(Color(.secondarySystemBackground))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
