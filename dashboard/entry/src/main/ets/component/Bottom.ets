import { router } from "@kit.ArkUI"
import { ThemeConfig } from "../model/ThemeConfig";
import PreferencesUtil from "../utils/PreferencesUtil";

@Component
export struct Bottom {
  @StorageProp('fontSize') fontSize: number = 20;
  @Link currentTheme: ThemeConfig
  @Prop mileage: number = 212
  @Prop activeTab: string = 'D'
  @State progress: number = 0.7
  @State textColor:Resource = $r("app.color.text_color")
  /**
   * 根据里程计算进度百分比
   * @returns 计算后的进度值(0-1之间)
   */
  private getMileageProgress(): number {
    return Math.min(this.mileage / 300, 1)
  }

  /**
   * 组件生命周期 - 即将出现时调用
   */
  aboutToAppear() {
    this.activeTab = PreferencesUtil.get('drivingMode', 'D') as string
    this.progress = this.getMileageProgress()
  }

  /**
   * 构建组件UI
   */
  build() {
    // 使用Stack布局实现底部固定定位
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Row() {
          Row({ space: 10 }) {
            Row() {
              Row()
                .width(`${this.progress * 100}%`)
                .height('100%')
                .backgroundColor('#ff4ccb44')

            }
            .width("50%")
            .height("30%")
            .backgroundColor('#E5E5E5')
            .margin({ right: 10 })

            Text(`${this.mileage} km`)
              .fontSize(this.fontSize)
              .fontColor(this.currentTheme.textColor)
              .fontWeight(FontWeight.Bold)

            Image($r("app.media.light_near"))
              .fillColor('#007AFF')
              .width('15%')
              .margin({ left: 50 })
          }
          .padding({ left: 70 })
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

          Row() {
            this.buildTab('P')  // 停车模式
            this.buildTab('D')  // 驾驶模式
            this.buildTab('R')  // 倒车模式
            this.buildTab('N')  // 空档模式
            this.buildTab('S')  // 运动模式
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

          Row(){
            Image($r('app.media.back'))
              .width('10%')
              .fillColor(this.currentTheme.iconColor)
              .onClick(() => {
                // 点击事件：跳转到主页
                router.back({
                  url: 'pages/MainPage',
                  params: this.currentTheme
                })
              })
          }
          .layoutWeight(1)
        }
        .width('100%')
        .height('100%')
        .alignItems(VerticalAlign.Center)
      }
    }
    .width('100%')
    .height('8%')
  }

  /**
   * 构建单个导航标签
   * @param tabName 标签名称
   * @returns 构建好的标签组件
   */
  @Builder
  buildTab(tabName: string) {
    Column() {
      Text(tabName)
        .fontSize(this.fontSize)
        .fontColor(this.activeTab === tabName
          ? $r('app.color.clicked') : this.currentTheme.iconColor)
        .margin({ bottom: 2 })

      if (this.activeTab === tabName) {
        Row()
          .width("8%")
          .height("8%")
          .backgroundColor('#007AFF')
          .margin({ top: 2 })
      }
    }
    .margin({ left: 18 })
    .onClick(() => {
      this.activeTab = tabName
      PreferencesUtil.put('drivingMode', tabName)
    })
  }
}