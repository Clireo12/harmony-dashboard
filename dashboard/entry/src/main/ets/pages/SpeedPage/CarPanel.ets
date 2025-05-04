import { City } from "../../component/City"
import { CirclePanel } from './CirclePanel';

@Component
export struct CarPanel {
  @Prop speed: number
  @Prop distance: number

  build() {
    Row() {
      CirclePanel({
        num: this.speed,
        unit: 'km/h',
        current: 100
      })

      // 路况
      Stack() {
        City()
          .scale({ x: 0.8 })
          .offset({ x: -13, y: -65 })

        Image($r('app.media.car2'))
          .width(200)
          .offset({ y: 50 })
      }
      .layoutWeight(1)

      CirclePanel({
        num: this.distance,
        unit: 'km',
        current: 100,
        reverse: true
      })
    }
    .layoutWeight(1)
    .height('100%')
  }
}