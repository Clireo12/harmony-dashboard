import { DrivingMode } from './DrivingMode'
import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { Constants } from './Constants'
import { Bottom } from '../../component/Bottom'
import { City } from '../../component/City'

@Entry
@Component
export struct VehicleStatusPage {
  // @State Width:number = 380
  @State Height:number = 380
  build() {
    Column(){

      Header()


      // 方向盘角度反馈,油门状态反馈,驾驶模式反馈组件
      Row(){
        SteeringWheelAngleFeedback({
          _height:this.Height
        })
          .margin({
            right:"3%"
          })

        DrivingMode({
          _height:this.Height
        })

        // 车辆图标展示
        Stack(){
          City()

          Image($r("app.media.car"))
            .width("45%")
            .offset({ y : 50})
        }
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Top)
      .margin({
        left:"5%"
      })
      .layoutWeight(1)

      Bottom()
    }
    .alignItems(HorizontalAlign.Start)
    .width(Constants.PAGE_WEIGHT)
    .height(Constants.PAGE_HEIGHT)
  }
}