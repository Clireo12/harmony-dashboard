import { theme } from "../../Singleton/singleton"

// 方向盘角度反馈组件
@Preview
@Component
export struct SteeringWheelAngleFeedback {
  @State _width:number|string = 300
  @State _height:number|string = 350
  @State bgkColor:Color|string = "#2B323A"
  @State angle:number = -270
  @State angleColor:Color|string = Color.Red
  @State Theme:theme = theme.getInstance();
  build() {

    Column({space:15}){
      Text("方向盘角度反馈")
        .fontColor(this.Theme.textColor[this.Theme.modeList[this.Theme.mode]])
        .margin({
          top:5
        })
      Stack(){
        Image($r("app.media.fang_xiang_pan_jiao_du"))
          .width("90%")
        Text(this.angle.toString()+"°")
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontColor(this.angleColor)
      }
    }
    .borderRadius(20)
    .backgroundColor(this.Theme.ComponentBGColor[this.Theme.modeList[this.Theme.mode]])
    .width(this._width)
    .height(this._height)

  }
}