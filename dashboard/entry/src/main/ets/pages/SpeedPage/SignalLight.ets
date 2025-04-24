@Component
export struct SignalLight {
  private light: ResourceStr[] = ['#f7f7f7','#f7f7f7','#f7f7f7']
  @Prop activeLight: number = 0  // 0左 1中 2右

  aboutToAppear(): void {
    this.light[this.activeLight] = $r('app.color.active_light')
  }

  build() {
    Column() {
      // 指示灯
      Row() {
        if (this.activeLight === 0) {
          Image($r('app.media.active_arrow'))
            .width(50)
        } else {
          Image($r('app.media.arrow'))
            .width(50)
            .rotate({ angle: 180 })
        }

        Row() {
          Text('←')
            .fontSize(36)
            .fontWeight(800)
            .fontColor(this.light[0])
          Text('↑')
            .fontSize(36)
            .fontWeight(800)
            .fontColor(this.light[1])
          Text('→')
            .fontSize(36)
            .fontWeight(800)
            .fontColor(this.light[2])
        }
        .margin({ left: 20, right: 20 })
        .padding({ left: 20, right: 20 })
        .width(200)
        .height(70)
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor($r('app.color.traffic_light_bg'))
        .borderRadius(10)

        if (this.activeLight === 2) {
          Image($r('app.media.active_arrow'))
            .width(50)
            .rotate({ angle: 180 })
        } else {
          Image($r('app.media.arrow'))
            .width(50)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}
