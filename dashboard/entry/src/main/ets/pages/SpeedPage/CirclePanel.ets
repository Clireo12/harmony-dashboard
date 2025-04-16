@Component
export struct CirclePanel {
  @Prop num: number // 数值
  @Prop unit: string // 单位

  build() {
    Row() {
      Stack() {
        Circle()
          .width(250)
          .height(250)
          .fillOpacity(0)
          .strokeWidth(8)
          .stroke('#81fa0000')
          .strokeDashArray([1, 2])
        Circle()
          .width(240)
          .height(240)
          .fill($r('app.color.dashboard_background'))
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
            .fontColor($r('app.color.text_color'))
            .fontWeight(600)
          Text(this.unit)
            .fontSize(20)
            .fontWeight(600)
            .offset({
              y: -5
            })
        }
      }
    }
    .height('100%')
    .backgroundColor($r('app.color.dashboard_background'))
  }
}