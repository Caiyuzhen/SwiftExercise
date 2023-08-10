import SwiftUI


struct FoodListView: View {

    @State private var food = Foods.examples //🚀这样下面 List 才能通过 $ 拿到 food 的 👋 Binding！！
    @State private var selectedFood = Set<Foods.ID>()
    
    var body: some View {
        //主 UI
        VStack(alignment: .leading) {//🔥左对齐
            //  顶部编辑区域
            HStack {
                // 标题 + icon
                Label("食物清单", systemImage: "fork.knife")
                    .font(.title2.bold())
                    .foregroundColor(.indigo)
                    .frame(maxWidth: .infinity, alignment: .leading) // 🚀 infinity 表示横向撑满
                    .padding(.leading, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                EditButton()
                    .buttonStyle(.bordered)
                    .padding(.trailing, 24)
            }
            
            //  食物列表
            List($food,
                 // id: \.name, 因为 Foods Model 定义了 Identifiable 的 UUID, 所以这里不用重复定义了
                 editActions: .all, //支持编辑（删除）
                 selection: $selectedFood //支持选中
            ) { $food in
                Text(food.name) // 食物列表
            }
        }.background(.listBg)
    }
}


struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
