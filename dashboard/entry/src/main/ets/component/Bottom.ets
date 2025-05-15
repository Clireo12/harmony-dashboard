import { router } from "@kit.ArkUI"
import { ThemeConfig } from "../model/ThemeConfig";
import PreferencesUtil from "../utils/PreferencesUtil";

@Component
export struct Bottom {
  @Link currentTheme: ThemeConfig
  @Prop mileage: number
  @Prop activeTab: string
  @State progress: number = 0.7
  @State textColor:Resource = $r("app.color.text_color")

  aboutToAppear() {
    this.activeTab = PreferencesUtil.get('drivingMode', 'P') as string
    const totalMileage = PreferencesUtil.get('TotalMileage', 0) as number
    this.mileage = totalMileage
  }

  build() {
        Row() {
          Row() {
            Image($r("app.media.light_near"))
              .fillColor('#007AFF')
              .width(40)
              .height(40)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End)

          Row() {
            this.buildTab('P')  // 停车模式
            this.buildTab('D')  // 驾驶模式
            this.buildTab('R')  // 倒车模式
            this.buildTab('N')  // 空档模式
            this.buildTab('S')  // 运动模式
          }
          .margin({ left: 50,right: 50 })
          .layoutWeight(1)
          .justifyContent(FlexAlign.SpaceBetween)

          Row(){
            Image($r('app.media.back'))
              .width('10%')
              .fillColor(this.currentTheme.iconColor)
              .onClick(() => {
                //跳转到主页
                router.back({
                  url: 'pages/MainPage'
                })
              })
          }
          .layoutWeight(1)
        }
        .width('100%')
        .height('8%')
  }

  @Builder
  buildTab(tabName: string) {
    Column() {
      Text(tabName)
        .fontSize(24)
        .fontColor(this.activeTab === tabName
          ? $r('app.color.clicked') : this.currentTheme.iconColor)
        .margin({ bottom: 1 })

      if (this.activeTab === tabName) {
        Row()
          .width("12%")
          .height("10%")
          .backgroundColor('#007AFF')
          .margin({ top: 1 })
      }
    }
    .onClick(() => {
      if (this.activeTab === tabName) return
      this.activeTab = tabName
      PreferencesUtil.put('drivingMode', tabName)
    })
  }
}
