import SwiftUI


//👇主 UI 界面
struct FoodListView: View {
    @State private var food = Foods.examples //🚀这样下面 List 才能通过 $ 拿到 food 的 👋 Binding！！ Foods.examples + Foods.examples  表示重复增加相同的数据
    @State private var selectedFood = Set<Foods.ID>()
    
    var body: some View {
        //主 UI
        VStack(alignment: .leading) {//🔥左对齐
            //  顶部编辑区域
            titleBar
            
            //  食物列表
            List($food,
                 // id: \.name, 因为 Foods Model 定义了 Identifiable 的 UUID, 所以这里不用重复定义了
                 editActions: .all, //支持编辑（删除）
                 selection: $selectedFood //支持选中
            ) { $food in
                Text(food.name) // 食物列表
            }
        }
        .background(.listBg)
        .safeAreaInset(edge: .bottom, alignment: .trailing) {//往下滚动时，会把 Add 按钮放在安全区域内，避免无法拖拽
            addBtn
        }
    }
}


//👇 UI 组件
private extension FoodListView {
    var titleBar: some View {
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
                .environment(\.locale, .init(identifier: "zh-chn")) //切换成简体中文的编辑按钮（不用写也行，会跟随系统而改变
        }
    }
    
    var addBtn: some View {
        // .overlay(alignment: .bottomTrailing) { //🚀右下角增加悬浮按钮
        Button {} label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
            //                    .background(.white, in: Circle()) //给按钮增加白色底
                .padding()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.accentColor.gradient)
            //            }
        }
    }
}


struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
