@Component
export struct CarPanel {

  build() {
    Column() {
      // 指示灯
      Row({ space: 50 }) {
        Image($r('app.media.active_arrow'))
          .width(60)

        Row() {

        }
        .width('60%')
        .height(70)
        .backgroundColor($r('app.color.traffic_light_bg'))
        .borderRadius(10)

        Image($r('app.media.arrow'))
          .width(60)
      }

      // 路况
      Column() {
        Image($r('app.media.city'))
          .width(500)
      }

    }
    .layoutWeight(1)
    .height('100%')
  }
}