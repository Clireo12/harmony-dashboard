@Component
export struct SignalLight {
  @State light: number[] = [0.3, 0.3, 0.3]
  @Prop activeLight: number  // 0红 1黄 2绿
  private timer: number = 0

  aboutToAppear(): void {
    this.light[this.activeLight] = 1
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
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
          Circle()
            .width(36)
            .height(36)
            .fill('#f00')
            .opacity(this.light[0])
          Circle()
            .width(36)
            .height(36)
            .fill('#ff0')
            .opacity(this.light[1])
          Circle()
            .width(36)
            .height(36)
            .fill('#0f0')
            .opacity(this.light[2])
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
