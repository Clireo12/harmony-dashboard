import { City } from "../../component/City"

@Component
export struct CarPanel {
  private light: ResourceStr[] = ['#f7f7f7','#f7f7f7','#f7f7f7']
  @Prop activeLight: number  // 0左 1中 2右

  aboutToAppear(): void {
    this.light[this.activeLight] = $r('app.color.active_light')
  }

  build() {
    Column({ space: 20 }) {
      // 指示灯
      Row() {
        if (this.activeLight === 0) {
          Image($r('app.media.active_arrow'))
            .width(60)
        } else {
          Image($r('app.media.arrow'))
            .width(60)
            .rotate({ angle: 180 })
        }

        Row() {
          Text('←')
            .fontSize(40)
            .fontWeight(800)
            .fontColor(this.light[0])
          Text('↑')
            .fontSize(40)
            .fontWeight(800)
            .fontColor(this.light[1])
          Text('→')
            .fontSize(40)
            .fontWeight(800)
            .fontColor(this.light[2])
        }
        .margin({ left: 20, right: 20 })
        .padding({ left: 50, right: 50 })
        .width('60%')
        .height(70)
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor($r('app.color.traffic_light_bg'))
        .borderRadius(10)

        if (this.activeLight === 2) {
          Image($r('app.media.active_arrow'))
            .width(60)
            .rotate({ angle: 180 })
        } else {
          Image($r('app.media.arrow'))
            .width(60)
        }
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