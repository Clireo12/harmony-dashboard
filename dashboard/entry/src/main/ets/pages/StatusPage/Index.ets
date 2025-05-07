import { DrivingMode } from './DrivingMode'
import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { Bottom } from '../../component/Bottom'
import { City } from '../../component/City'
import { ThemeManager } from '../../model/ThemeManager';
import { ThemeConfig } from '../../model/ThemeConfig'

@Entry
@Component
struct VehicleStatusPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  @State Height:number = 380


  build() {
    Column(){
      Header({ currentTheme: this.currentTheme })

      // 方向盘角度反馈,油门状态反馈,驾驶模式反馈组件
      Row(){
        SteeringWheelAngleFeedback()
          .width("25%")
          .height("90%")
          .margin({
            right:"3%"
          })

        DrivingMode()
          .width("25%")
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

      Bottom({ currentTheme: this.currentTheme })
    }
    .backgroundColor(this.currentTheme.theme)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Start)
    .width("100%")
    .height("100%")
  }
}


export { VehicleStatusPage }
