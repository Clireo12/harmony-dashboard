@Component
export struct Header {
  @State date: Date = new Date()
  @State time: string = ''
  @State timeState: string = ''
  @Prop temperature: number = 23.5
  @Prop TotalMileage: number = 2800
  @State timer: number = -1

  /**
   * 组件生命周期 - 即将出现时调用
   */
  aboutToAppear() {
    const timeDesc: string[] = ['上午', '中午', '下午']
    // 初始化变量
    this.timer = setInterval(() => {
      this.date = new Date()
      this.time = this.date.toTimeString().split(' ')[0]
      this.timeState = timeDesc[Math.floor(parseInt(this.time.split(':')[0]) / 8)]
    }, 1000)
  }

  /**
   * 组件生命周期 - 即将退出时调用
   */
  aboutToDisappear() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  build() {
    Row(){
      Row({ space: 40 }){
        Row({ space: 10 }) {
          Text(this.timeState)
            .fontSize(20)
          Text(this.time)
            .fontSize(20)
        }

        Row({ space: 10 }) {
          Image($r('app.media.sun_right'))
            .width(22)
          Text(`${this.temperature}℃`)
            .fontSize(20)
        }
      }
      .width(200)

      Row({ space: 10 }){
        Button(){
          Text('<')
        }
        .backgroundColor($r('app.color.dashboard_background'))

        Image($r('app.media.leaf'))
          .width(25)
        Text('ECO')

        Button(){
          Text(">")
        }
        .backgroundColor($r('app.color.dashboard_background'))
        .margin({
          right:20
        })

        Image($r("app.media.leaf"))
          .width(25)

        Text("东南")
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Row({ space: 10 }){
        Text('总里程')
          .fontSize(20)
        Text(`${this.TotalMileage} km`)
          .fontSize(20)
      }
      .width(200)
      .justifyContent(FlexAlign.End)
    }
    .padding({ left: 50, right: 50 })
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.Transparent) // 后期需要根据时间,修改黑夜或白天模式
  }
}
