@Preview
@Component
struct Header {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.dashboard_background'))
  }
}