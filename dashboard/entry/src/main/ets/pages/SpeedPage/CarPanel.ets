import { City } from "../../component/City"

@Component
export struct CarPanel {

  build() {
    Column({ space: 20 }) {
      // 指示灯
      Row() {
        Image($r('app.media.active_arrow'))
          .width(60)

        Row() {

        }
        .margin({ left: 20, right: 20 })
        .width('60%')
        .height(70)
        .backgroundColor($r('app.color.traffic_light_bg'))
        .borderRadius(10)

        Image($r('app.media.arrow'))
          .width(60)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)

      // 路况
      Stack() {
        City()
          .offset({ y: -65 })

        Image($r('app.media.car2'))
          .width(300)
          .offset({ y: 50 })
      }

    }
    .layoutWeight(1)
    .height('100%')
  }
}