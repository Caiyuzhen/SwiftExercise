import SwiftUI



struct ContentView: View {
    let food = ["汉堡", "沙拉", "披萨", "义大利麵", "鸡腿便当", "刀削麵", "火锅", "牛肉麵", "关东煮"]
    
    @State private var selectedFood: String? //存放选好的 food, 用 @State 来声明, 可以在数据变动时更新 UI，类似 useState~

    let customColor = Color(red: 0.28, green: 0.22, blue: 0.9, opacity: 1) //自定义颜色
    
    // 👇渲染 UI
    var body: some View {
        VStack(spacing: 10) {//垂直排列(类似 flex)
            Text("今天吃什么？")
                .font(.largeTitle)
                .bold()
                .padding(.all, 6.0)
            
            
            Image("hambuger")
                .resizable()
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
            }
            
            
            // 👇用带 label 的 Button 可以调整按钮的样式
            Button(role: .none) {
                selectedFood = food.shuffled().filter { $0 != selectedFood }.first //shuffled() 利用原始数组返回一个新的数组，其中包含原始数组中的元素，但顺序是随机的； $0 ! 表示过滤掉跟当前一样的元素，随机抽取下一个非当前元素的元素
            } label: {
                Text("手气不错")
                    .padding(/*@START_MENU_TOKEN@*/.all, 8.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50, alignment: .center) // 改变按钮宽度
            }
                .background(customColor)
                .cornerRadius(12)
             
			
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
        .padding().opacity(0.8)
        .animation(.easeInOut(duration: 0.3), value: selectedFood) //⚡️这个动画要放在 VStack 身上，是因为要在 VStack 开始出现时就开始观察动画，动画的时间跟变化速率 、变化的对象（比如食物文字发生变化，就执行动画）
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
