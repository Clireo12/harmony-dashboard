
// 方向盘角度反馈组件
@Preview
@Component
export struct SteeringWheelAngleFeedback {
  @State _width:number|string = 300
  @State _height:number|string = 350
  @State bgkColor:Color|string = "#2B323A"
  @State angle:string = '-270°'
  @State angleColor:Color|string = Color.Red
  build() {

    Column({space:15}){
      Text("方向盘角度反馈")
        .fontColor(Color.White)
        .margin({
          top:5
        })
      Stack(){
        Image($r("app.media.fang_xiang_pan_jiao_du"))
          .width("90%")
        Text(this.angle)
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontColor(this.angleColor)
      }
    }
    .borderRadius(20)
    .backgroundColor(this.bgkColor)
    .width(this._width)
    .height(this._height)

  }
}