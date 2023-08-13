import SwiftUI


private enum MyField: Int {//用来让 keyboard 认识表单的顺序 【1】, Int 是为了通过数字的加减来用 < and > 去 change 切换列表
    case title, image, calories, protein, fat, carb
}


// 👇切换到下一列的方法
private extension TextField where Label == Text {
    func focusedFn(_ field: FocusState<MyField?>.Binding, equals this: MyField) -> some View{
        submitLabel(this == .carb ? .done : .next) //keyboard 右下角为 next 【3】 LabeledContent\onSubmit 只能用在 TextField 上
        .focused(field, equals: this) //keyboard 右下角为 next 【4】
        .onSubmit { //keyboard 右下角为 next 【5】，表示下一个是 xx
            field.wrappedValue = .init(rawValue: this.rawValue + 1) //用 + - 的方式切换到下一个
        }
    }
}


extension FoodListView { //把 FoodListView 置入到 FoodForm 内
    struct FoodForm: View {
        
        @Environment(\.dismiss) var dismiss //🌟User for close sheets aroused raise by add Btn, ⚡️ 都可以通过 【dismiss】 这个系统 state！
        @FocusState private var field: MyField?//用来让 keyboard 认识表单的顺序 【2】
        @State var food: Foods //🌟 State 的修改只发生在当前 View 内

        var onSubmitFoodData: (Foods) -> Void // 🚀🚀🚀 用来新增 add 的食物！

        


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
            NavigationStack { //⌨️要自定义 toolbar 的键盘的话, 前提是最上层 should write NavigationStack!!
                VStack {
                    // 顶栏 Header
                    HStack {
                        Label("编辑食物资料", systemImage: "pencil")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                        Image(systemName: "xmark.circle.fill") //🌟🌟 close the sheet by use @Environment Statue, 这个 state 是全局 state
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .onTapGesture {
                                dismiss() // close the add sheet panel
                            }
                    }.padding([.top, .horizontal], 32)
                    
                    
                    // 👇Add 打开的表单
                    Form {
                        LabeledContent("名称") { //固定名称
                            TextField("请输入食物名称", text: $food.name) //【第一步】
                                .focusedFn($field, equals: .title)
                                // .submitLabel(.next) //keyboard 右下角为 next 【3】 LabeledContent\onSubmit 只能用在 TextField 上
                                // .focused($field, equals: .title) //keyboard 右下角为 next 【4】
                                // .onSubmit { //keyboard 右下角为 next 【5】，表示下一个是 xx
                                //     field = .image //切换到下一个
                                // }
                        }
                        
                        LabeledContent("图片") { //固定名称
                            TextField("请输入食物 Emoji，最多输入 2 个字符", text: $food.image) //【第一步】
                                .focusedFn($field, equals: .image)
                                // .submitLabel(.next) //keyboard 右下角为 next 【3】
                                // .focused($field, equals: .image) //keyboard 右下角为 next 【4】
                                // .onSubmit { //keyboard 右下角为 next 【5】，表示下一个是 xx
                                //     field = .calories //切换到下一个
                                // }
                        }

                        // LabeledContent("热量") { //固定名称
                        //                        HStack {
                        //                            TextField("", value: $food.calorie, //【第一步】
                        //                                  format: .number.precision(.fractionLength(1)) //🔥格式化到小数点的第一位
                        //                            )
                        //                            Text("大卡")
                        //                        }
                        //                    }
                        buildNumFiled(title: "热量", value: $food.calorie, currentField: .calories, suffix: "大卡")
                            // .submitLabel(.next) //keyboard 右下角为 next 【3】
                            // .focused($field, equals: .calories) //keyboard 右下角为 next 【4】
                            // .onSubmit { //keyboard 右下角为 next 【5】，表示下一个是 xx
                            //     field = .protein //切换到下一个
                            // }

                        buildNumFiled(title: "蛋白质", value: $food.protein, currentField: .protein)
                            // .submitLabel(.next) //keyboard 右下角为 next 【3】
                            // .focused($field, equals: .protein) //keyboard 右下角为 next 【4】
                            // .onSubmit { //keyboard 右下角为 next 【5】，表示下一个是 xx
                            //     field = .fat //切换到下一个
                            // }

                        buildNumFiled(title: "脂肪", value: $food.fat, currentField: .fat)
                            // .submitLabel(.next) //keyboard 右下角为 next 【3】
                            // .focused($field, equals: .fat) //keyboard 右下角为 next 【4】
                            // .onSubmit { //keyboard 右下角为 next 【5】，表示下一个是 xx
                            //     field = .carb //切换到下一个
                            // }

                        buildNumFiled(title: "碳水", value: $food.carb, currentField: .carb)
                            // .submitLabel(.next) //keyboard 右下角为 next 【3】
                            // .focused($field, equals: .carb) //keyboard 右下角为 next 【4】
                            // .onSubmit { //keyboard 右下角为 next 【5】，表示下一个是 xx
                            //     field = .carb //切换到下一个
                            // }


                        // Section {
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
                    .padding(.top, -2)
                    // .formStyle(.columns) //当成一列来
                    Button { //按下保存按钮
                        dismiss()
                        onSubmitFoodData(food) //👈👈👈👈  在 FoodListView 的 .sheet 中把食物的数据新增进去
                    } label: {
                        Text(invaildMsg ?? "保存").frame(maxWidth: .infinity).frame(height: 36).bold()
                    }
                    .mainBtnStyle()
                    .padding()
                    .disabled(isNotClick) //🔥🔥内置的按钮 disable 方法
                }
                .background(.bgBody)
                .multilineTextAlignment(.trailing) //右对齐
                .scrollDismissesKeyboard(.interactively) //⚡️⚡️close keyboard 关闭键盘
                .toolbar {//🚀自定义底部工具栏 < > 切换 列表
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(action: goPreviousField) {
                            Image(systemName: "chevron.up")
                        }
                        Button(action: goNextField) {
                            Image(systemName: "chevron.down")
                        }
                        // Text("<")Text(">")
                    }
                }
            }
        }

        func goPreviousField() {
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue - 1)
        }

        func goNextField() {
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue + 1)
        }
        



        // 渲染食物表单中的每一列
        private func buildNumFiled(title: String, value: Binding<Double>, currentField: MyField, suffix: String = "g") -> some View {
           // LabeledContent("热量") { //固定名称
              LabeledContent(title) { //固定名称
                HStack {
                    TextField(
                          "",
                          value: value, //【第一步】
                          format: .number.precision(.fractionLength(1)) //🔥格式化到小数点的第一位
                    )
                    .focusedFn($field, equals: currentField)
                    .keyboardType(.numbersAndPunctuation) //让在输入 热量、calorie 时候，键盘变为数字
                    Text(suffix)
                   // Text("大卡")
                }
            }
        }
    }
}



//👇建立预览设备
struct FoodForm_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView.FoodForm(food: Foods.examples.first!)  { _ in }  //👈👈👈👈  在 FoodListView 的 .sheet 中把食物的数据新增进去
    }
}


