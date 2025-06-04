import { themeConfig, ThemeConfig } from "../../model/ThemeConfig"
import { Animator } from "@kit.ArkUI";

@Component
export struct SignalLight {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();
  @State speed: number = 30 // 车速
  @State distance: number = 212 // 里程数
  @StorageLink("gear_state") gear_state:string = 'S'
  @Link activeLight: number  // 0-左转，2-右转，1-直行

  timer: number = -1
  @State currentOpacity: number = 0

  // 根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
  }

  aboutToAppear() {
    this.timer = setInterval(() => {
      this.currentOpacity = 1 - this.currentOpacity
    }, 500)
  }

  aboutToDisappear() {
    clearInterval(this.timer)
  }

  build() {
    Column() {
      // 指示灯
      Row() {
        if (this.activeLight === 0) {
          Stack() {
            Image($r('app.media.active_arrow'))
              .width(50)
              .opacity(this.currentOpacity)
            Image($r('app.media.arrow'))
              .width(50)
              .rotate({ angle: 180 })
              .opacity(1 - this.currentOpacity)
          }
        } else {
          Image($r('app.media.arrow'))
            .width(50)
            .rotate({ angle: 180 })
        }

        Text(this.gear_state)   //档位显示，需要根据实际时速动态判断档位
          .fontSize(50)
          .fontColor(this.currentTheme.textColor)
          .margin({ left: 50, right: 50 })

        if (this.activeLight === 2) {
          Stack() {
            Image($r('app.media.active_arrow'))
              .width(50)
              .rotate({ angle: 180 })
              .opacity(this.currentOpacity)
            Image($r('app.media.arrow'))
              .width(50)
              .opacity(1 - this.currentOpacity)
          }
        } else {
          Image($r('app.media.arrow'))
            .width(50)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}
