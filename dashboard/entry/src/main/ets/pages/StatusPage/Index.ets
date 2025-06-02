import { DrivingMode } from './DrivingMode'
import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { Bottom } from '../../component/Bottom'
import { City } from '../../component/City'
import { ThemeManager } from '../../model/ThemeManager'
import { ThemeConfig } from '../../model/ThemeConfig'
import IotDataTool from '../../utils/IotDataTool'
import { Snow } from '../WeatherDisplay/Snow';
import { router } from '@kit.ArkUI'
import { CirclePanel } from '../SpeedPage/CirclePanel'

@Entry
@Component
struct VehicleStatusPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  @State Height:number = 380
  @State isSnowMode: boolean = false
  @State rotateAngle: number = 0
  @State rotateAngle1: number = 0  //最外层圆圈
  @State rotateAngle2: number = 0  //中间层圆圈
  @State rotateAngle3: number = 0  //最内层圆圈
  @Prop reverse: boolean = false

  aboutToAppear() {
    IotDataTool.login()

    // 外层圆圈动画 (每60ms旋转3度)
    setInterval(() => {
      this.rotateAngle1 += 3
      if (this.rotateAngle1 >= 360) {
        this.rotateAngle1 = 0
      }
    }, 60)

    // 中层圆圈动画 (反向，每40ms旋转4度)
    setInterval(() => {
      this.rotateAngle2 -= 4
      if (this.rotateAngle2 <= -360) {
        this.rotateAngle2 = 0
      }
    }, 40)

    // 内层圆圈动画 (每30ms旋转5度)
    setInterval(() => {
      this.rotateAngle3 += 5
      if (this.rotateAngle3 >= 360) {
        this.rotateAngle3 = 0
      }
    }, 30)
  }

  navigateToDashboard() {
    router.pushUrl({ url: 'pages/SpeedPage/Index' });
  }

  build() {
    Column(){
      Header({ currentTheme: this.currentTheme })

      Column(){
        Row() {
          Image($r("app.media.back"))
            .width(40)
            .fillColor(this.currentTheme.iconColor)
            .onClick(() => {
              this.navigateToDashboard()
            })
            .margin({ left: 32 })
        }
        .width('100%')
        .height(30)
        .justifyContent(FlexAlign.Start)

        Row({space: 100}){

          Column(){
            Column(){
              Row() {
                    Text("方向盘角度反馈")
                      .fontSize(20)
                      .fontColor(this.currentTheme.textColor)
                      .margin({ bottom: 5 })
              }
              .width('50%')
              .height(50)

              Column(){
                  SteeringWheelAngleFeedback() //方向盘角度
                    .height("90%")
              }
              .width('100%')
            }
            .width('100%')
            .height('88%')
            .borderRadius(25)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.currentTheme.mask)
            .padding(10)
          }
          .width("32%")
          .height("100%")
          .justifyContent(FlexAlign.Center)

          Column() {
            Text('自检功能')
              .height(50)
              .fontSize(20)
              .fontColor(this.currentTheme.textColor)

            Stack() {

              Circle()
                .width(240)
                .height(240)
                .fill($r('app.color.circle_one'))
                .shadow(ShadowStyle.OUTER_DEFAULT_XS)
                .rotate({ angle: this.rotateAngle1 })

              Circle()
                .width(190)
                .height(190)
                .fill($r('app.color.circle_two'))
                .shadow(ShadowStyle.OUTER_DEFAULT_XS)
                .rotate({ angle: this.rotateAngle2 })

              Circle()
                .width(140)
                .height(140)
                .fill($r('app.color.circle_three'))
                .shadow(ShadowStyle.OUTER_DEFAULT_XS)
                .rotate({ angle: this.rotateAngle3 })

              Circle()
                .width(100)
                .height(100)
                .fill(this.currentTheme.theme)

              //显示数值和单位
              Column() {
                Text("自检中")
                  .fontSize(24)
                  .fontWeight(600)
                  .fontColor(this.currentTheme.textColor)

              }
            }
              .layoutWeight(1)

            Column({ space: 10 }) {
              Text('车胎自检中...')
                .fontSize(15)
                .fontColor(Color.Gray)
              Text('水压自检中...')
                .fontSize(15)
                .fontColor(Color.Gray)
              Text('机油压力自检中...')
                .fontSize(15)
                .fontColor(Color.Gray)
            }
            .height(100)
          }
          .shadow( ShadowStyle.OUTER_DEFAULT_XS)
          .width('35%')
          .height('88%')
          .backgroundColor(this.currentTheme.mask)
          .borderRadius(25)
        }
        .width("100%")
        .height("85%")
        .justifyContent(FlexAlign.Center)
      }

    }
    .backgroundColor(this.currentTheme.theme)
    .width("100%")
    .height("100%")

  }
}

export { VehicleStatusPage }

