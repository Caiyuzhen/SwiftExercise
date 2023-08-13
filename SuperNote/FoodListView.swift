import SwiftUI


// 👇 sheet 的三种不同的视图
private enum SheetShow: View, Identifiable {
    case newFood((Foods) -> Void) //接收一个食物的回调
    case editFood(Binding<Foods>)
    case foodDetail(Foods) //传入食物


    var id: UUID {
        switch self {
            case .newFood:
                return UUID()

            case .editFood(let binding):
                return binding.wrappedValue.id //连接过去的 id 并进行返回 （同一个数据）

            case .foodDetail(let food):
                return food.id
        }
    }


    var body: some View {
        switch self {
            case .newFood(let onSubmit):
                FoodListView.FoodForm(food: .new, onSubmitFoodData: onSubmit)  //👈👈👈👈  新增食物 data

            case .editFood(let binding):
                FoodListView.FoodForm(food: binding.wrappedValue) { binding.wrappedValue = $0 } // $0 表示初始值为 0

            case .foodDetail(let food):
                FoodListView.FoodDetailSheet(food: food)
        }
    }
}


//👇主 UI 界面
struct FoodListView: View {
    @Environment(\.editMode) var editMode // 判断是否进入了编辑状态

    @State private var food = Foods.examples //🚀这样下面 List 才能通过 $ 拿到 food 的 👋 Binding！！ Foods.examples + Foods.examples  表示重复增加相同的数据
    @State private var selectedFoodID = Set<Foods.ID>() // 选中的 list
    @State private var sheet: SheetShow? //🚀抽象出来后, 只需要一个 sheet

    var isEditing: Bool { editMode?.wrappedValue == .active } //当编辑状态 = 正在编辑则为 true => 点了【编辑】按钮

    // @State private var shouldShowSheet: Bool = false //是否显示底部 sheet
    // @State private var shouldShowFoodForm: Bool = false // 是否显示食物的新建菜单
    // @State private var selectedFoodItem: Binding<Foods>? //🔥🔥🔥🔥🔥🔥编辑 sheet, 把点中编辑的那项给显示出来, 并且把更新后的数值返回给 FoodForm



    var body: some View {
        //主 UI
        VStack(alignment: .leading) {//🔥左对齐
            //  顶部编辑区域
            titleBar
            
            //  食物列表
            List($food, // id: \.name, 因为 Foods Model 定义了 Identifiable 的 UUID, 所以这里不用重复定义了
                 editActions: .all, //支持编辑（删除）
                 selection: $selectedFoodID, //支持选中
                 rowContent: buildFoodRowFn //👈👈抽象出来了显示食物列表的方法
            )
            // {
            //     $food in
            //        HStack {
            //            Text(food.name).padding(.vertical, 8.0) // 食物列表
            //                .frame(maxWidth: .infinity, alignment: .leading) // 为了让 list 能够点击唤起底部的 sheet
            //                .contentShape(Rectangle()) // 让整个 list 的热区都能点击
            //                .onTapGesture {
            //                    if isEditing { return } //如果是正在【编辑】的状态, 则不打开底部 sheet
            //                    sheet = .foodDetail(food)//🔥🔥点击每行列表时, 显示底部食物菜单 （抽象出来的方法)）
            //                    // shouldShowSheet = true //🔥🔥点击每行列表时, 显示底部食物菜单
            //                }
            //            //👇按钮编辑状态
            //            if isEditing {
            //                Image(systemName: "pencil")
            //                    .font(.title2.bold())
            //                    .foregroundColor(.gray)
            //                    .onTapGesture {
            //                        sheet = .editFood($food) //🔥🔥🔥🔥🔥🔥编辑 shee, 把点中编辑的那项给显示出来, 传入 【绑定 binding 】的食物, 让数据唯一！
            //                        // selectedFoodItem = $food //🔥🔥🔥🔥🔥🔥编辑 sheet, 把点中编辑的那项给显示出来, 并且把更新后的数值返回给 FoodForm
            //                    }
            //            }
            //        }
            // }
        }
        .background(.listBg)
        .safeAreaInset(edge: .bottom, content: buildFloatBtn) //【🔥右下角 add 按钮的安全区】往下滚动时，会把 Add 按钮放在安全区域内，避免无法拖拽, 🚀根据是否是编辑状态显示不同的按钮 => alignment: isEditing ? .center : .trailing



        //🔥🔥🔥🔥🔥🔥编辑 sheet, 把点中编辑的那项给显示出来, 并且把更新后的数值返回给 FoodForm
        // .sheet(item: $selectedFoodItem, content: { food in
        //     FoodForm(food: food.wrappedValue) { food.wrappedValue = $0 } // $0 表示初始值为 0
        // })



        //🔥【新增食物】 Show sheet According to【shouldShowFoodForm】
        .sheet(item: $sheet) { $0 }
        // .sheet(isPresented: $shouldShowFoodForm) {
        //     FoodForm(food: Foods(name: "", image: "")) { food in self.food.append(food) } //👈👈👈👈  新增食物 data
        // }



        // 🔥【根据 $shouldShowSheet 显示底部菜单】isPressented: .constant(true) 表示固定强制显示
        // .sheet(isPresented: $shouldShowSheet) {
        //全部抽象在底部了...
        // }
    }
}




// ⚡️ 子画面更新时去通知父画面做高度的变更
private extension FoodListView {

    //抽象出来的展示 sheet 食物信息的方法
    struct FoodDetailSheet: View {
        public struct FoodListDetailSheetHeightKey: PreferenceKey {
            static var defaultValue: CGFloat = 300 //预设值

            static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
                value = nextValue() // 更新成新的数字
            }
        }


        @Environment(\.dynamicTypeSize) private var lsyoutStyle //判断是否是辅助模式，是则显示横向排版
        @State private var foodDetailHeight: CGFloat = FoodListDetailSheetHeightKey.defaultValue //读取下面所定义的预设值

        let food: Foods //显示哪一张 sheets 的食物信息
        
        var body: some View {
            let useHStackLayout = lsyoutStyle.isAccessibilitySize || food.image.count > 1//判断是否是辅助模式, 或者食物图的数量是否 > 1
            let layout = useHStackLayout ? AnyLayout(HStackLayout(spacing: 30)) : AnyLayout(VStackLayout(spacing: 30))


            // 👇食物 sheet 条件排版！！！【方法一, 做抽象】👇
               // AnyLayout.useVStack(if: shouldVStack, spacing: 30) {Text ...} //使用

            // 👇食物 sheet 不使用条件排版 【不做抽象】
               // VStack(spacing: 32) {...}


            // 👇食物 sheet 条件排版！！！【方法二, 不做抽象】👇
            layout {
                   // Text("Hey~, \(food.image)") //这里的 \(XXX) 类似模板字符串
                Text(food.image) //这里的 \(XXX) 类似模板字符串
                    .font(.system(size: 120))
                    .lineLimit(1) //🚀限制一行
                    .minimumScaleFactor(useHStackLayout ? 0.5 : 1) //限制最小只能缩放到 0.5, 如果是垂直排版的话就是 1, 横向排版则为 0.5
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    buildInfoListView(title:"热量", value:food.$calorie)
                    buildInfoListView(title:"蛋白", value:food.$protein)
                    buildInfoListView(title:"脂肪", value:food.$fat)
                    buildInfoListView(title:"碳水", value:food.$carb)
                       // GridRow {
                       //     Text("热量").gridCellAnchor(.leading).bold() //cell 左对齐
                       //     Text(food.$calorie).gridCellAnchor(.trailing) //cell 右对齐
                       // }
                       //
                       // GridRow {
                       //     Text("蛋白质").gridCellAnchor(.leading).bold() //cell 左对齐
                       //     Text(food.$protein).gridCellAnchor(.trailing) //cell 右对齐
                       // }
                       //
                       // GridRow {
                       //     Text("脂肪").gridCellAnchor(.leading).bold() //cell 左对齐
                       //     Text(food.$fat).gridCellAnchor(.trailing) //cell 右对齐
                       // }
                       //
                       // GridRow {
                       //     Text("碳水").gridCellAnchor(.leading).bold() //cell 左对齐
                       //     Text(food.$carb).gridCellAnchor(.trailing) //cell 右对齐
                       // }
                }
            }
            .padding()
            .padding(.vertical)
            .overlay { //🚀根据内容的大小来展示卡片的尺寸
                // ⚡️ 子画面更新时去通知父画面做高度的变更
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: FoodListDetailSheetHeightKey.self,
                        value: proxy.size.height
                    )
                }
            }
            .onPreferenceChange(FoodListDetailSheetHeightKey.self) { // 更新上面定义的 @State 的值
                foodDetailHeight = $0
            }
            .presentationDetents([.height(foodDetailHeight)]) // 更新 sheet 的高度
             // .presentationDetents([.medium, .height(600)]) //🌟 sheet 固定在中间, 最多能向上拖动到 500 的位置
        }


        // sheet 卡片上 list 排列信息的方法
        func buildInfoListView(title: String, value:String) -> some View {
            GridRow {
                Text(title).gridCellAnchor(.leading).bold()
                Text(value).gridCellAnchor(.trailing)
            }
        }
    }
}



//👇建立根据是否是辅助模式来展示不同 layout 的方法抽象
extension AnyLayout {
    static func useVStack(if condition: Bool, spacing: CGFloat, @ViewBuilder content: @escaping() -> some View) -> some View { //因为离开这个 view 还会继续存在, 所以加上 @escaping
        let layout = condition ? AnyLayout(HStackLayout(spacing: spacing)) : AnyLayout(VStackLayout(spacing:spacing))
        return layout(content)
    }
}




//👇 UI 组件
private extension FoodListView {
    
    //  顶部 Title
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
            
            EditButton() // 编辑按钮
                .buttonStyle(.bordered)
                .padding(.trailing, 24)
                .environment(\.locale, .init(identifier: "zh-chn")) //切换成简体中文的编辑按钮（不用写也行，会跟随系统而改变
        }
    }
    




    // add 按钮
    var addBtn: some View {
        // .overlay(alignment: .bottomTrailing) { //🚀右下角增加悬浮按钮
        Button {
            // Add 按钮的事件
            // change shouldShowFoodForm to true

            sheet = .newFood { food.append($0) } 
            // shouldShowFoodForm = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .padding()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.accentColor.gradient)
            //                    .background(.white, in: Circle()) //给按钮增加白色底
            //            }
        }
    }
    




    // 删除的操作
    var removeBtn: some View {
        Button {
            withAnimation {    //增加删除的动画
                food = food.filter { !selectedFoodID.contains($0.id) } //过滤掉需要被删除的元素
            }
        } label : {
            Text("删除选中的清单")
                .font(.callout.bold())
                .frame(width: 180, height: 38, alignment: .center)
        }
        .mainBtnStyle(shape: .roundedRectangle(radius: 6)) //🔥【mainBtnStyle】所造 Extensions 内定义的
        .padding(.horizontal, 50)
    }
    




    // 底部两个按钮
    func buildFloatBtn() -> some View {
        //  底部按钮 => 如果正在编辑，则显示删除按钮，否则为新增
        ZStack {
               // if isEditing {
                removeBtn
                    .transition(
                        .move(edge: .leading)
                        .animation(.easeInOut)
                        .combined(with: .opacity) //加上透明度的变化
                    )
                    .opacity(isEditing ? 1 : 0)
                    .id(isEditing)
//                } else {
                HStack { //加这个是为了让按钮能够根据中心进行缩放
                    Spacer()//挤压按钮的空间
                    addBtn
                       // 【写法一】
                       //     .transition(
                       //         .scale //按钮缩小的动画
                       //         .animation(.easeInOut)
                       //         .combined(with: .opacity) //加上透明度的变化
                       //     )
                       //     .opacity(isEditing ? 0 : 1)
                       //     .id(isEditing)
                       // 【写法二】
                        .scaleEffect(isEditing ? 0 : 1)
                        .animation(.easeInOut, value: isEditing)
                        .opacity(isEditing ? 0 : 1)
                }
               // }
        }
    }


    // 👇抽象出来的显示食物列表的方法
    func buildFoodRowFn(foodBinding: Binding<Foods>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
             Text(food.name).padding(.vertical, 8.0) // 食物列表
                 .frame(maxWidth: .infinity, alignment: .leading) // 为了让 list 能够点击唤起底部的 sheet
                 .contentShape(Rectangle()) // 让整个 list 的热区都能点击
                 .onTapGesture {
                     if isEditing { return } //如果是正在【编辑】的状态, 则不打开底部 sheet
                     sheet = .foodDetail(food)//🔥🔥点击每行列表时, 显示底部食物菜单 （抽象出来的方法)）

                 }
             //👇按钮编辑状态
             if isEditing {
                 Image(systemName: "pencil")
                     .font(.title2.bold())
                     .foregroundColor(.gray)
                     .onTapGesture {
                         sheet = .editFood(foodBinding) //🔥🔥🔥🔥🔥🔥编辑 shee, 把点中编辑的那项给显示出来, 传入 【绑定 binding 】的食物, 让数据唯一！

                     }
             }
         }
    }
}




//测试不同的设备大小
struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
//        FoodListView().previewDevice(.iPhoneSE)
//        FoodListView().previewDevice(.iPhoneSE).environment(\.dynamicTypeSize, .accessibility1)//打开辅助模式
//        FoodListView().environment(\.editMode, .constant(.active)) //⚡️⚡️强制变成编辑状态
    }
}
