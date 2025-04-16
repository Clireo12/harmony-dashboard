@Preview
@Component
struct CirclePanel {
  @State num: string = 'Hello World';

  build() {
    RelativeContainer() {
      Stack() {
        Circle()
          .width(300)
          .height(300)
          .fill($r('app.color.dashboard_background'))
        Circle()
          .width(290)
          .height(290)
          .fill('#1096ed')
        Circle()
          .width(210)
          .height(210)
          .fill('#5eb2ea')
        Circle()
          .width(150)
          .height(150)
          .fill('#37566a')
        Circle()
          .width(120)
          .height(120)
          .fill('#000')
        Text()
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.dashboard_background'))
  }
}