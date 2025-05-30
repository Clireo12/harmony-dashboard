import { themeConfig, ThemeConfig } from "../../model/ThemeConfig"

@Component
export struct SignalLight {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();
  @State light: number[] = [0.3, 0.3, 0.3]
  @Link activeLight: number  // 0-左转，2-右转，1-直行
  private timer: number = 0
  @State speed: number = 30 // 车速
  @State distance: number = 212 // 里程数

  // 根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
  }

  aboutToAppear(): void {
    this.light[this.activeLight] = 1
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Column() {
      // 指示灯
      Row() {
        if (this.activeLight === 0) {
          Image($r('app.media.active_arrow'))
            .width(50)
        } else {
          Image($r('app.media.arrow'))
            .width(50)
            .rotate({ angle: 180 })
        }
        Text("S")   //档位显示，需要根据实际时速动态判断档位
          .fontSize(50)
          .fontColor(this.currentTheme.textColor)
          .margin({ left: 50, right: 50 })

        // Row() {
        //   Circle()
        //     .width(36)
        //     .height(36)
        //     .fill('#f00')
        //     .opacity(this.light[0])
        //   Circle()
        //     .width(36)
        //     .height(36)
        //     .fill('#ff0')
        //     .opacity(this.light[1])
        //   Circle()
        //     .width(36)
        //     .height(36)
        //     .fill('#0f0')
        //     .opacity(this.light[2])
        // }
        // .margin({ left: 20, right: 20 })
        // .padding({ left: 20, right: 20 })
        // .width(200)
        // .height(70)
        // .justifyContent(FlexAlign.SpaceBetween)
        // .backgroundColor($r('app.color.traffic_light_bg'))
        // .borderRadius(10)

        if (this.activeLight === 2) {
          Image($r('app.media.active_arrow'))
            .width(50)
            .rotate({ angle: 180 })
        } else {
          Image($r('app.media.arrow'))
            .width(50)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}
