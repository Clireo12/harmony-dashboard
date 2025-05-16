import { themeConfig, ThemeConfig } from '../../model/ThemeConfig';
import { ThemeManager } from '../../model/ThemeManager';

@Component
export struct CirclePanel {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();

  @Prop num: number // 数值
  @Prop unit: string // 单位
  @Prop reverse: boolean = false // 反向
  @Prop current: number // 当前数值百分比
  private gradientColor: LinearGradient = new LinearGradient([
    { color: this.reverse ? $r('app.color.speed_high') : $r('app.color.speed_low'), offset: 0.3 },
    { color: $r('app.color.speed_mid'), offset: 0.6 },
    { color: this.reverse ? $r('app.color.speed_low') : $r('app.color.speed_high'), offset: 1.0 }
  ])

  private timeCheckTimer: number | null = null;//时间检查定时器

  //根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
  }

  //启动时间检查器
  private startTimeChecker() {
    this.timeCheckTimer = setInterval(() => {
      this.currentTheme = this.getTimeBasedTheme();
    }, 60000); //每分钟检查一次
  }

  build() {
    Row() {
      Stack() {
        Progress({ value: this.current / 2, total: 100, type: ProgressType.Ring })
          .width(270)
          .color(this.gradientColor)
          .backgroundColor(Color.Transparent)
          .style({
            strokeWidth: 8,
            shadow: true
          })
          .rotate({ angle: this.reverse ? 30 : 150 })

        Circle()
          .width(200)
          .height(200)
          .fill($r('app.color.circle_one'))

        Circle()
          .width(150)
          .height(150)
          .fill($r('app.color.circle_two'))

        Circle()
          .width(100)
          .height(100)
          .fill($r('app.color.circle_three'))

        Circle()
          .width(80)
          .height(80)
          .fill(this.currentTheme.theme)

        Column() {
          Text(this.num.toString())
            .fontSize(36)
            .fontColor(this.currentTheme.textColor)
            .fontWeight(600)
          Text(this.unit)
            .fontSize(20)
            .fontWeight(600)
            .fontColor(this.currentTheme.textColor)
            .offset({
              y: -5
            })
        }

      }
    }
    // .height('100%')
    .backgroundColor(Color.Transparent)
  }
}