import SwiftUI


extension FoodListView { //置入到
    struct FoodForm: View {
        
        @State var food: Foods //🌟 State 的修改只发生在当前 View 内
        private var isNotClick: Bool {
            food.name.isEmpty || food.image.count > 2 || food.image.count <= 0 //🚀🚀【各种不合法的情况】如果食物名称为空或者图片 > 2 个字符 则 isNotClick 为 false
        }
        
        private var invaildMsg: String? { //🌟统一定义的文案, 在【底部按钮】上进行提升
            if food.name.isEmpty { return "请输入名称" }
            if food.image.count <= 0 { return "请输入图片 Emoji" }
            if food.image.count > 2 { return "图片 Emoji 字数过多" }
            return .none
        }
        
        var body: some View {
            VStack {
                Label("编辑食物资料", systemImage: "pencil")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                
                // 👇表单
                Form {
                    LabeledContent("名称") { //固定名称
                        TextField("请输入食物名称", text: $food.name) //【第一步】
                    }
                    LabeledContent("图片") { //固定名称
                        TextField("请输入食物 Emoji", text: $food.image) //【第一步】
                    }
                    //                    LabeledContent("热量") { //固定名称
                    //                        HStack {
                    //                            TextField("", value: $food.calorie, //【第一步】
                    //                                  format: .number.precision(.fractionLength(1)) //🔥格式化到小数点的第一位
                    //                            )
                    //                            Text("大卡")
                    //                        }
                    //                    }
                                        buildNumFiled(title: "热量", value: $food.calorie, suffix: "大卡")
                                        buildNumFiled(title: "蛋白质", value: $food.protein)
                                        buildNumFiled(title: "脂肪", value: $food.fat)
                                        buildNumFiled(title: "碳水", value: $food.carb)
                    //                    Section {
                    //                        Text("ABC")
                    //                        Text("ABC")
                    //                    } header: {
                    //                        Text("Header")
                    //                    } footer: {
                    //                        Text("Footer")
                    //                    }
                    //
                    //                    Section {
                    //                        Text("ABC")
                    //                        Text("ABC")
                    //                    } header: {
                    //                        Text("Header")
                    //                    } footer: {
                    //                        Text("Footer")
                    //                    }
                }
                //               .formStyle(.columns) //当成一列来
                Button {
                    
                } label: {
                    Text(invaildMsg ?? "保存").frame(maxWidth: .infinity).frame(height: 36)
                }
                .mainBtnStyle()
                .padding()
                .disabled(isNotClick) //🔥🔥内置的按钮 disable 方法
            }
            
            .background(.bgBody)
            .multilineTextAlignment(.trailing) //右对齐
        }
        
        private func buildNumFiled(title: String, value: Binding<Double>, suffix: String = "g") -> some View {
//            LabeledContent("热量") { //固定名称
              LabeledContent(title) { //固定名称
                HStack {
                    TextField("", value: value, //【第一步】
                          format: .number.precision(.fractionLength(1)) //🔥格式化到小数点的第一位
                    )
                    Text(suffix)
//                    Text("大卡")
                }
            }
        }
    }
    
}

//👇建立预览设备
struct FoodForm_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView.FoodForm(food: Foods.examples.first!)  //【第二步】
    }
}


