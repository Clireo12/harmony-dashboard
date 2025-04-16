import { Bottom } from '../../component/Bottom';
import { CirclePanel } from './CirclePanel';
import { SidePanel } from './SidePanel';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Row({ space: 10 }) {
        SidePanel({
          warning: true,
          charge: true,
          carDoor: true,
          fan: true,
          temp: 20
        })

        CirclePanel({
          num: 80,
          unit: 'km/h'
        })

        Blank()
          .width(200)

        CirclePanel({
          num: 80,
          unit: 'km/h'
        })

        SidePanel({
          warning: true,
          charge: true,
          carDoor: true,
          fan: true,
          temp: 20
        })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Bottom()
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.dashboard_background'))
  }
}