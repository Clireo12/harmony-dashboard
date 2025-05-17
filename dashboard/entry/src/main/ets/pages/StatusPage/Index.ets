import { DrivingMode } from './DrivingMode'
import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { Bottom } from '../../component/Bottom'
import { City } from '../../component/City'
import { ThemeManager } from '../../model/ThemeManager'
import { ThemeConfig } from '../../model/ThemeConfig'
import IotDataTool from '../../utils/IotDataTool'
import { Snow } from './Snow'

@Entry
@Component
struct VehicleStatusPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  @State Height:number = 380
  @State selectedIndex: number = 0 //0:方向盘角度, 1:驾驶模式
  private tabs: string[] = ['方向盘角度', '驾驶模式']
  @State isSnowMode: boolean = false

  aboutToAppear() {
    IotDataTool.login()
  }


  build() {
    Column(){
      Header({ currentTheme: this.currentTheme })

      Row({space: 30}){

        Column(){
          Column(){
            Row() {
              ForEach(this.tabs, (item: string, index: number) => {
                Column() {
                  Text(item)
                    .fontSize(this.selectedIndex === index ?22 : 18)
                    .fontColor(this.currentTheme.textColor)
                    .margin({ bottom: 5 })

                  Divider()
                    .color(this.selectedIndex === index ?
                    this.currentTheme.textColor: Color.Transparent)
                    .strokeWidth(2)
                    .width('80%')
                }
                .width('50%')
                .height(40)
                .justifyContent(FlexAlign.Center)
                .onClick(() => {
                  this.selectedIndex = index
                })
              })
            }
            .width('100%')
            .height(50)
            .margin({ bottom: 10 })

            Column(){
              if (this.selectedIndex === 0) {
                SteeringWheelAngleFeedback() //方向盘角度
                  .height("85%")
              } else {
                DrivingMode({
                  onModeChange: (modeIndex: number) => {
                    this.isSnowMode = modeIndex === 3; //雪地模式
                  }
                })
                  .height("85%")
              }
            }
            .width('100%')
          }
          .width('100%')
          .height('85%')
          .borderRadius(25)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.currentTheme.mask)
          .padding(10)
        }
        .width("32%")
        .height("100%")
        .margin({left:15,right:15})
        .justifyContent(FlexAlign.Center)

        Column(){
            Stack() {

              City().offset({ y: -55 })

              Image($r("app.media.car"))
                .width("80%")
                .offset({ y: 50 })

              if (this.isSnowMode) {
                Stack() {
                  ForEach(Array.from({length: 30}), (item: undefined, index: number) => {
                    Snow()
                      .position({
                        x: Math.random() * 100 + '%',
                        y: Math.random() * 100 + '%'
                      })
                  })
                }
                .width('90%')
                .height('90%')
                .position({ x: 0, y: 20 })
              }
            }
            .width('100%')
            .height('100%')
            .position({ x: 0, y: 0 })
          }
        .width("55%")
        .height("85%")
        .borderRadius(25)
        .backgroundColor(Color.White)
      }
      .width("100%")
      .height("100%")
      .margin({
        left:"5%",
      })
      .layoutWeight(1)

      Bottom({ currentTheme: this.currentTheme })
    }
    .backgroundColor(this.currentTheme.theme)
    .width("100%")
    .height("100%")
    .margin({right:15})

    //   // 方向盘角度反馈,油门状态反馈,驾驶模式反馈组件
    //   Row(){
    //     SteeringWheelAngleFeedback()
    //       .width("25%")
    //       .height("90%")
    //       .margin({
    //         right:"3%"
    //       })
    //
    //     DrivingMode()
    //       .width("25%")
    //       .height("90%")
    //     // 车辆图标展示
    //     Stack(){
    //       City()
    //       Image($r("app.media.car"))
    //         .width("45%")
    //         .offset({ y : 50})
    //     }
    //   }
    //   .width("100%")
    //   .height("100%")
    //   .justifyContent(FlexAlign.Start)
    //   .alignItems(VerticalAlign.Top)
    //   .margin({
    //     left:"5%"
    //   })
    //   .layoutWeight(1)
    //
    //   Bottom({ currentTheme: this.currentTheme })
    // }
    // .backgroundColor(this.currentTheme.theme)
    // .justifyContent(FlexAlign.SpaceBetween)
    // .alignItems(HorizontalAlign.Start)
    // .width("100%")
    // .height("100%")
  }
}

export { VehicleStatusPage }

