import SwiftUI



//👇核心界面框架
struct ContentView: View {
//    let food = ["沙拉", "披萨", "义大利麵", "鸡腿便当", "刀削麵", "火锅", "牛肉麵", "关东煮"]
//    @State private var selectedFood: String? //存放选好的 food, 用 @State 来声明, 可以在数据变动时更新 UI，类似 useState~
    @State private var isSelectedFood: Foods? //是否展示食物图片
    @State private var isShowInfo: Bool = true // //是否展示食物信息卡片
    let food = Foods.examples
    let customColor = Color(red: 0.28, green: 0.22, blue: 0.9, opacity: 1) //自定义颜色
    
    
    // 👇整个界面的 UI
    var body: some View { //some 表示不透明【类型】
        ScrollView {
            VStack(spacing: 10) {
                Text("今天吃什么？")
                    .font(.largeTitle).bold().padding(.all, 6.0)
                    .foregroundStyle(
                        .linearGradient(colors: [.pink, .indigo],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing)
                    )
                
                // 顶部图片
                foodImage
                
                // 👇食物图片 + 文字
                selectedFoodInfoView
            
                
                if(isSelectedFood != .none) {
                    Spacer().layoutPriority(1)//增加空白填充, 避免画面动来动去, layoutPriority 是设置调整器的优先级
                }
                
                
                // 👇底部按钮 -- 用带 label 的 Button 可以调整按钮的样式
                selectedBtn
                
                cancelBtn
            }
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 100)//背景无限延伸 （调整器的位置很重要！）
            .padding().opacity(1)
            .animation(.smallEase, value: isSelectedFood) //⚡️【食物出现的动画】这个动画要放在 VStack 身上，是因为要在 VStack 开始出现时就开始观察动画，动画的时间跟变化速率 、变化的对象（比如食物文字发生变化，就执行动画）, 表示给用到了 selectedFood 这个属性的元素增加动画
            .animation(.smallSpring, value: isShowInfo)//⚡️⚡️⚡️【Info 卡片下弹动画】表示给用到了 showInfo 这个属性的元素增加动画！ => smallSpring 表示后续我们自己抽象出来的属性
        }
        .background(.bgBody) //🚀🚀 在 Extensions 改成计算属性后, 就可以忽略 Color
//        .background(Color.bgBody) //背景底色
    }
    
}



// MARK - 下面都是食物详情页的 Subviews
private extension ContentView {
    // 上方【食物图片】 View
    var foodImage: some View {
        //👇 如果有食物则显示【食物图】
        Group { //🚀给里边所有元素加上同样的属性
            if(isSelectedFood != .none) {
//                GeometryReader { geometry in

                    Circle().fill(.yellow).overlay { //Circle() 给背景加个 ⭕️
                        Text(isSelectedFood!.image) //显示 Foods内的 emoji
                            .font(.system(size: 160))
                            .minimumScaleFactor(0.5)//字体至少有 0.5 倍大
                            .lineLimit(1) //👈限制只能显示一行
                    }
                    .scaleEffect(x: 1.1, y: 1.1, anchor: .center).opacity(1) // 【缩放】圆形并将缩放中心定位到圆形的中心点
                    .opacity((isSelectedFood != .none) ? 1 : 0)
//                    .animation(.smallEase, value: isSelectedFood)
                    .transition(.delayInsertionOpacity)
                    .zIndex(-10)
//                }.zIndex(-100)
            } else {
                Image("hambuger") //默认显示的元素
                    .resizable() // 🚀（调整器的位置很重要！因为每一行都会返回自己的 View）
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 240.0, height: 240.0) //高度跟 图片本身 一样大
        .animation(.smallEase, value: isSelectedFood)
    }
    
    
    //  中间【食物名称】View
    var foodNameView: some View {
            HStack {
                Text(isSelectedFood!.name)//文字展示为 => selectedFood 食物名
                    .font(.system(size: 24))
                    .padding(.vertical, 10)
                    .bold()
                    .foregroundColor(customColor)
                    .id(isSelectedFood!.name) // 🔥设定了 id 后, Swift UI 就会明确转场的是不同的对象效果为淡入淡出
                    .transition(.delayInsertionOpacity)
                // .transition(.scale.combined(with: .slide)) //组合动画
            
            Button {
                isShowInfo.toggle() //🚀 toggle 为 boolean 封装好的切换方法
                } label: {
                    Image(systemName: "info.circle.fill") //info icon
                        .foregroundColor(.secondary)
            }
        }
    }
    
    
    // 底部【营养信息卡片】
    var foodDetailView: some View {
        VStack { //👈 VStack 用来固定 Info 菜单往下出现的动画范围
            if isShowInfo {
                //【排版方式二】 ————————————————————————————————————————————————————————————————————————
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    GridRow {
                        Text("蛋白质")
//                            .fixedSize(horizontal: false, vertical: true) //表示强制让垂直方向获得最大空间
//                            .multilineTextAlignment(.leading)//左对齐
//                            .lineSpacing(20)
                        Text("脂肪")
                        Text("碳水")
                    }.frame(minWidth: 80)
                    
                    Divider()
                        .gridCellUnsizedAxes(.horizontal) //gridCellUnsizedAxes 指不要分配给这个 grid 元素额外的空间, 避免撑满整个画面
                        .padding(.horizontal, -4) // .horizontal, -4 表示增加一下分割线的宽度
                    //                            .rotationEffect(.degrees(90))
                    
                    GridRow {
                        Text(isSelectedFood!.$protein)
                        Text(isSelectedFood!.$fat)
                        Text(isSelectedFood!.$carb)
//                        buildInfoCardNumberText(isSelectedFood!.protein)
//                        buildInfoCardNumberText(isSelectedFood!.fat)
//                        buildInfoCardNumberText(isSelectedFood!.carb)
                        
//                        Text(isSelectedFood!.protein.formatted() + "g")
//                        Text(isSelectedFood!.fat.formatted() + "g")
//                        Text(isSelectedFood!.carb.formatted() + "g")
                    }
                }
                .padding()
                .roundRectBg() // 抽象出来的颜色方法
                .frame(width: .infinity, height: 80.0) //背景色高度跟 图片 一样大
                .transition(.moveUpOpacity) //🔥给信息卡片的动画增加透明度的变化！
                .cornerRadius(12) // 增加圆角
                
                
                //【排版方式一】 ————————————————————————————————————————————————————————————————————————
                //                    VStack { //垂直排列(类似 flex)
                //                        HStack {
                //                            VStack(spacing: 12) {
                //                                Text("蛋白质")
                //                                Text(selectedFood!.protein.formatted() + "g")
                //                            }
                //
                //                            Divider().frame(width: 1).padding(.horizontal) //水平方向增加间距, 🔥要先定义 frame 为 1dp, 然后再增加 padding
                //
                //                            VStack(spacing: 12) {
                //                                Text("脂肪")
                //                                Text(selectedFood!.fat.formatted() + "g")
                //                            }
                //
                //                            Divider().frame(width: 1).padding(.horizontal)  //水平方向增加间距, 🔥要先定义 frame 为 1dp, 然后再增加 padding
                //
                //                            VStack(spacing: 12) {
                //                                Text("碳水")
                //                                Text(selectedFood!.carb.formatted() + "g")
                //                            }
                //                        }
                //                        .padding(.horizontal) //🚀需要加在 background 之前！
                //                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color(.systemBackground)))
                //                    }.frame(width: .infinity, height: 80.0) //背景色高度跟 图片 一样大
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .clipped()
        // .border(.red)
    }
    
//    // 创建 xxg xxg 的方法，避免重复写(但也不建议在 Vide 进行处理，应该在 Model 处理）
//    func buildInfoCardNumberText(_ number: Double) -> some View {
//        Text(number.formatted() + "g")
//    }
    
    
    // 随机按钮
    var selectedBtn: some View {
        Button(role: .none) {
            withAnimation { //👈这个加了后会只影响当前这个元素, 单独让它有动画, 可以设置有动画的时机
                isSelectedFood = food.shuffled().filter { $0 != isSelectedFood }.first //shuffled() 利用原始数组返回一个新的数组，其中包含原始数组中的元素，但顺序是随机的； $0 ! 表示过滤掉跟当前一样的元素，随机抽取下一个非当前元素的元素
            }
        } label: {
            Text(isSelectedFood == .none ? "告诉我" : "手气不错")
                .animation(.none, value: isSelectedFood) //删除文字的渐变动画（系统默认效果）
                .foregroundColor(.white)
                .frame(width: 180, height: 38, alignment: .center) // 改变按钮宽度
                .transformEffect(.init(translationX: 0, y: 0)) //明确文字的位置（ 涉及到了 Swift 内置动画的原理, Swift 内置了转场动画跟位移动画, 避免让文字元素产生上下移动的效果, 相当于不让位置变化）
        }
        .mainBtnStyle() //抽象出来的按钮样式
    }
    
    
    // 重置按钮
    var cancelBtn: some View {
        Button(role: .none) {
            isSelectedFood = .none
            isShowInfo = true //重置 info 卡片的状态
        } label: {
            Text("重置")
                .padding(.all, 8.0)
                .foregroundColor(.white)
                .frame(width: 200, height: 50, alignment: .center) // 用文字撑开按钮宽度
        }
        .background(.black)
        .cornerRadius(12)
    }
    
    
    
    // 食物信息 (汇总）
    @ViewBuilder var selectedFoodInfoView: some View { //🚀因为 if XXX 是没有用产生 view 的 return , 所以这里需要 @ViewBuilder!!
        if(isSelectedFood != .none) {
            //👇中间【食物名称】
            foodNameView
           
            
             
            //👇【热量】
//            Text("热量 \(isSelectedFood!.calorie.formatted()) 大卡") //calorie 是 selectedFood 内的一个参数
                Text("热量 \(isSelectedFood!.$calorie)") //🔥能使用 $ 是因为 Foods 定义了格式！
                    .font(.subheadline).bold()
                    .padding(.bottom, 20)
            
            
            // 👇【营养信息卡片】
            foodDetailView
        }
        // 🚀👇下面两种实现方式会产生不同的动画
        //            selectedFood != .none ? Color.pink : Color.blue //【运算值的方式】, 会被判断为【同一个元素 - 同一个 View】, 因此会变成补帧的【形变动画】
        //            if selectedFood != .none { //【条件值的方式】, 会被判断为【不同的元素 - 不同的 View】, 就会发生【转场动画】,因为 if 语句会被包装成 EitherView
        //                Color.pink
        //            } else {
        //                Color.blue
        //            }
        //          Color.clear //增加空白填充, 避免画面动来动去
    }
}



extension ContentView {
    init(slectedFood: Foods) {
        _isSelectedFood = State(wrappedValue: slectedFood)
    }
}



extension PreviewDevice {
    static let iPad = PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)")
    static let iPhoneSE = PreviewDevice(rawValue: "iPhone SE (3rd generation)")
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(slectedFood: .examples.first!) //模拟器
        ContentView(slectedFood: .examples.first!).previewDevice(.iPad) //模拟器, 需要在全局内定义好静态属性！
    }
}
