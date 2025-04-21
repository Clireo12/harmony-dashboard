import { DrivingMode } from './DrivingMode'
import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { Bottom } from '../../component/Bottom'
import { City } from '../../component/City'


@Entry
@Component
export struct VehicleStatusPage {
  @State Height:number = 380




  // onPageShow(): void {
  //   this.WIDTH = this.wm.getWidth() > 0 ? this.wm.getWidth():1920
  //   this.HEIGHT = this.wm.getHeight() > 0 ? this.wm.getHeight():1080
  // }


  build() {
    Column(){
      Header()

      // 方向盘角度反馈,油门状态反馈,驾驶模式反馈组件
      Row(){
        SteeringWheelAngleFeedback()
          .width("20%")
          .height("90%")
          .margin({
            right:"3%"
          })

        DrivingMode()
          .width("20%")
          .height("90%")
        // 车辆图标展示
        Stack(){
          City()
          Image($r("app.media.car"))
            .width("45%")
            .offset({ y : 50})
        }
      }
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Top)
      .margin({
        left:"5%"
      })
      .layoutWeight(1)

      Bottom()
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r("app.color.start_window_background"))
    .alignItems(HorizontalAlign.Start)
    .width("100%")
    .height("100%")
  }
}