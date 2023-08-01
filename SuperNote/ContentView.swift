import SwiftUI



struct ContentView: View {
    let food = ["汉堡", "沙拉", "披萨", "义大利麵", "鸡腿便当", "刀削麵", "火锅", "牛肉麵", "关东煮"]
    
    @State private var selectedFood: String? //存放选好的 food, 用 @State 来声明, 可以在数据变动时更新 UI，类似 useState~

    let customColor = Color(red: 0.28, green: 0.22, blue: 0.9, opacity: 1) //自定义颜色
    
    // 👇渲染 UI
    var body: some View {
        VStack(spacing: 10) {//垂直排列(类似 flex)
            Image("hambuger")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240.0, height: 240.0)
                
//            Image(systemName: "globe")//systemName 是使用系统内置的 icon
//                .imageScale(.large)
//                .foregroundColor(.accentColor)//换成强调色（蓝色）
            
            if(selectedFood != .none) {
                Text(selectedFood ?? "")//selectedFood 为食物名
                    .font(.system(size: 16))
            }
            
        
            Text("今天吃什么？")
                .font(.largeTitle)
                .bold()
                .padding(/*@START_MENU_TOKEN@*/.all, 6.0/*@END_MENU_TOKEN@*/)
            
            Button("手气不错") {
                selectedFood =
                food.shuffled().filter { $0 != selectedFood }.first //shuffled() 利用原始数组返回一个新的数组，其中包含原始数组中的元素，但顺序是随机的； $0 ! 表示过滤掉跟当前一样的元素，随机抽取下一个非当前元素的元素
            }
                .padding(/*@START_MENU_TOKEN@*/.all, 8.0/*@END_MENU_TOKEN@*/)
                .background(customColor)
                .cornerRadius(6)
                .foregroundColor(.white)
				// 改变按钮宽度
				.frame(width: 200.0, height: 50.0)
			
			Button("重置") {
				selectedFood = .none
			}
				.padding(.all, 8.0)
                .background(.gray)
				.cornerRadius(6)
				.foregroundColor(.white)
            
            
        }
        .padding().opacity(0.8)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
