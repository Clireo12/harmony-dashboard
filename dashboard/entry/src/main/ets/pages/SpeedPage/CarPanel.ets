import { City } from "../../component/City"
import { CirclePanel } from './CirclePanel';
import { router } from "@kit.ArkUI";

@Component
export struct CarPanel {
  @Link speed: number //车速
  @Link distance: number  //里程数
  @Link activeLight: number
  @State carMove: number = 3  //控制车辆移动

  navigateToVehicleStatus() {
    router.pushUrl({ url: 'pages/StatusPage/Index' });
  }

  build() {
    Row() {
      CirclePanel({
        num: this.speed,
        unit: 'km/h',
        current: 100
      })

      //路况
      Stack() {
        City()
          .scale({ x: 0.85 })
          .offset({ x: -40, y: -65 })

        Stack(){
          //车辆图像
          if (this.activeLight === 0) { //左
            Image($r('app.media.car2'))
              .width(250)
              .offset({  y: 50 })

          } else if (this.activeLight === 2) {  //右
            Image($r('app.media.car2'))
              .width(250)
              .offset({ x: 5, y: 50 })

          } else {    //直行
            Image($r('app.media.car2'))
              .width(250)
              .offset({ y: 50 })
          }
        }.onClick(() => {
          this.navigateToVehicleStatus();
        })
      }
      .layoutWeight(1)

      CirclePanel({
        num: this.distance,
        unit: 'km',
        current: 100,
        reverse: true
      })
    }
  }
}