import { Bottom } from '../component/Bottom';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Bottom()
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.dashboard_background'))
  }
}