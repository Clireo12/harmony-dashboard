import { ThemeManager } from '../../model/ThemeManager';



// 方向盘角度反馈组件
@Component
export struct SteeringWheelAngleFeedback {
  private themeManager: ThemeManager = ThemeManager.getInstance();

  @State bgkColor:Color|string = "#2B323A"
  @State angle:number = -270
  @State angleColor:Color|string = Color.Red
  build() {
    Column({space:15}){
      Text("方向盘角度反馈")
        .textAlign(TextAlign.Center)
        .fontSize(15)
        .width("100%")
        .height("10")
        .fontColor(this.themeManager.getCurrentTheme().textColor)
        .margin({
          top:5
        })
      Stack(){
        Image($r("app.media.fang_xiang_pan_jiao_du"))
          .width("88%")

        Text(this.angle.toString()+"°")
          .textAlign(TextAlign.Center)
          .fontSize(28)
          .fontColor(this.angleColor)
      }
      .width("100%")
      .height("95%")
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .borderRadius(20)
    .backgroundColor(this.themeManager.getCurrentTheme().mask)

  }
}