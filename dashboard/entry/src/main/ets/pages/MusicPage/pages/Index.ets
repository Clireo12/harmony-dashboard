import Player from '../pages/Player';
import Content from '../pages/Content';

@Component
@Entry
struct Index {
  build() {
    Column() {

      Content()
        .width('100%')
        .height('80%')

      Player()
        .width('100%')
        .height('20%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffe0e9f1')
  }
}