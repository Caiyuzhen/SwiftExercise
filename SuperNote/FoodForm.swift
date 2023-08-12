import SwiftUI


extension FoodListView { //置入到
    struct FoodForm: View {
        var body: some View {
            
            VStack {
                Label("编辑食物资料", systemImage: "pencil")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                
                // 👇表单
                Form {
                    Section {
                        Text("ABC")
                        Text("ABC")
                    } hesder: {
                        Text("Header")
                    } footer: {
                        Text("Footer")
                    }
                }
            }
        }
    }
    
}

//👇建立预览设备
struct FoodForm_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView.FoodForm()
    }
}


