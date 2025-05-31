import { themeConfig, ThemeConfig } from '../../model/ThemeConfig';

@Component
export struct CirclePanel {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();

  @Prop num: number //数值
  @Prop unit: string //单位
  @Prop reverse: boolean = false //反向
  @Prop current: number //当前数值百分比
  maxSpeed: number = 100 // 最大显示时速

  private gradientColor: LinearGradient = new LinearGradient([
    { color: this.reverse ? $r('app.color.speed_high') : $r('app.color.speed_low'), offset: 0.3 },
    { color: $r('app.color.speed_mid'), offset: 0.6 },
    { color: this.reverse ? $r('app.color.speed_low') : $r('app.color.speed_high'), offset: 1.0 }
  ])

  //根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
  }

  build() {
    Row() {
      Stack() {
        Progress({ value: this.current / 2, total: this.maxSpeed, type: ProgressType.Ring })
          .width(300)
          .color(this.gradientColor)
          .backgroundColor(Color.Transparent)
          .style({
            strokeWidth: 10,
            shadow: true
          })
          // .rotate({ angle: this.reverse ? 180 : 150 })
          .rotate(this.reverse ? { angle: 30 } : { angle: 150 })

        Circle()
          .width(240)
          .height(240)
          .fill($r('app.color.circle_one'))

        Circle()
          .width(190)
          .height(190)
          .fill($r('app.color.circle_two'))

        Circle()
          .width(140)
          .height(140)
          .fill($r('app.color.circle_three'))

        Circle()
          .width(100)
          .height(100)
          .fill(this.currentTheme.theme)

        //显示数值和单位
        Column() {
          Text(this.num.toString())
            .fontSize(39)
            .fontColor(this.currentTheme.textColor)
            .fontWeight(600)
          Text(this.unit)
            .fontSize(23)
            .fontWeight(600)
            .fontColor(this.currentTheme.textColor)
            .offset({
              y: -5
            })
        }
      }
    }
    .backgroundColor(Color.Transparent)
  }
}