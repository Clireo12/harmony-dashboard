import { ThemeManager } from '../../model/ThemeManager';

@Component
export struct CirclePanel {
  private themeManager: ThemeManager = ThemeManager.getInstance();

  @Prop num: number // 数值
  @Prop unit: string // 单位
  @Prop reverse: boolean = false // 反向
  @Prop current: number // 当前数值百分比
  private gradientColor: LinearGradient = new LinearGradient([
    { color: this.reverse ? $r('app.color.speed_high') : $r('app.color.speed_low'), offset: 0.3 },
    { color: $r('app.color.speed_mid'), offset: 0.6 },
    { color: this.reverse ? $r('app.color.speed_low') : $r('app.color.speed_high'), offset: 1.0 }
  ])

  build() {
    Row() {
      Stack() {
        Progress({ value: this.current / 2, total: 100, type: ProgressType.Ring })
          .width(300)
          .color(this.gradientColor)
          .backgroundColor(Color.Transparent)
          .style({
            strokeWidth: 8,
            shadow: true
          })
          .rotate({ angle: this.reverse ? 30 : 150 })

        Circle()
          .width(230)
          .height(230)
          .fill($r('app.color.circle_one'))

        Circle()
          .width(180)
          .height(180)
          .fill($r('app.color.circle_two'))

        Circle()
          .width(130)
          .height(130)
          .fill($r('app.color.circle_three'))

        Circle()
          .width(110)
          .height(110)
          .fill($r('app.color.dashboard_background'))

        Column() {
          Text(this.num.toString())
            .fontSize(65)
            .fontColor(this.themeManager.getCurrentTheme().textColor)
            .fontWeight(600)
          Text(this.unit)
            .fontSize(20)
            .fontWeight(600)
            .fontColor(this.themeManager.getCurrentTheme().textColor)
            .offset({
              y: -5
            })
        }

      }
    }
    .height('100%')
    .backgroundColor(Color.Transparent)
  }
}