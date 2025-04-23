

// 驾驶状态组件
@Component
export struct DrivingMode {
  @State leftState:number = 1;
  @State left:string = "40%";
  uiContext: UIContext | undefined = undefined;
  @State DrivingMode: string[] = ['经济模式','运动模式','雪地模式','城市模式']
  private selectedMode:number|number[] = 1
  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
  }

  build() {
    Column(){
      // 油门/刹车状态
      Column({space:30}){
        Text("油门/刹车状态")
          .fontSize(15)
          .fontColor($r("app.color.text_color"))
          .backgroundColor($r("app.color.Component_Color"))
          .margin({
            top:3
          })
        Row(){
          // 状态切换显示按钮
          Row(){
            Row(){
              Text(this.leftState == 1 ? "刹车":"油门")
                .fontSize(18)
                .fontColor($r("app.color.text_color"))
            }
            .shadow({ radius: 10, color: Color.Gray })
            .width("60%")
            .height("100%")
            .margin({
              left:this.left
            })
            .backgroundColor("#FF7500")
            .borderRadius(25)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              console.log("Clicked")
              this.uiContext?.keyframeAnimateTo({ iterations: 1 }, [
                {
                  // 第一段关键帧动画时长为800ms，left属性做从0到40的动画
                  duration: 400,
                  event: () => {
                    if (this.leftState == 1) {
                      this.left = "0%"
                    }else {
                      this.left = "40%"
                    }
                    // console.log(this.left)
                  }
                },
              ]);
              this.leftState ^= 1
            })

          }
          .width("84%")
          .height("100%")
          .borderRadius(25)
          .backgroundColor("#0E62A9")
        }
        .justifyContent(FlexAlign.Center)
        .width("100%")
        .height("33%")
      }
      .width("100%")
      .height("45%")
      .borderRadius(15)
      .backgroundColor($r("app.color.Component_Color"))

      Row(){

      }
      .width("100%")
      .height("10%")

      // 驾驶模式
      Row(){
        Column(){
          Text("驾驶模式切换")
            .fontSize(15)
            .fontColor($r("app.color.text_color"))
            .backgroundColor($r("app.color.Component_Color"))
            .margin({
              top:3
            })

          TextPicker({range:this.DrivingMode, selected:1})
            // 选中的选项的字体样式
            .selectedTextStyle({
              color: "#007CE6",
              font: {
                size: '28vp',
                weight: FontWeight.Regular
              }
            })
            // 未选中的选项的字体样式
            .textStyle({
              color: "#0E62AA",
              font: {
                size: '18vp',
                weight: FontWeight.Regular
              }
            })
            // 取消Picker的分割线
            .divider(null)
            // 滑动该组件后触发回调函数, 获取当前选中的驾驶模式
            .onChange((value: string | string[], index: number | number[]) => {
              console.info('Picker item changed, value: ' + value + ', index: ' + index)
              this.selectedMode = index
            })
            .width("100%")
            .height("80%")

        }
        .width("100%")
        .height("100%")
        .borderRadius(15)
        .backgroundColor($r("app.color.Component_Color"))
      }
      .width("100%")
      .height("45%")
      .justifyContent(FlexAlign.Center)
    }
    .justifyContent(FlexAlign.SpaceBetween)
  }
}



