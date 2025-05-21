import { City } from "../../component/City"
import { CirclePanel } from './CirclePanel';

@Component
export struct CarPanel {
  @Link speed: number
  @Link distance: number
  @Link activeLight: number
  @State carMove: number = 3

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

        if (this.activeLight === 0) {
          Image($r('app.media.car2'))
            .width(200)
            .offset({ x: -10, y: 50 })
            .rotate({ angle: -15 })
        } else if (this.activeLight === 2) {
          Image($r('app.media.car2'))
            .width(200)
            .offset({ x: 10, y: 50 })
            .rotate({ angle: 15 })
        } else {
          Image($r('app.media.car2'))
            .width(200)
            .offset({ y: 50 })
        }
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