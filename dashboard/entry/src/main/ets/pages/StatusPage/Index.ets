import { DrivingMode } from './DrivingMode'
import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { Constants } from './Constants'
import { Bottom } from '../../component/Bottom'
import { City } from '../../component/City'
import { themeConfig, ThemeConfig, ThemeKey } from '../../model/ThemeConfig'
import { theme } from '../../Singleton/singleton'

@Entry
@Component
export struct VehicleStatusPage {
  // @State Width:number = 380
  @State Height:number = 380
  private WIDTH:number = 1920   // 暂时设定为屏幕高宽
  private HEIGHT:number = 1080
  @State nowTheme:theme = theme.getInstance()
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
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(this.nowTheme.mask[this.nowTheme.mode])
    .alignItems(HorizontalAlign.Start)
    .width(this.WIDTH)
    .height(this.HEIGHT)
  }
}