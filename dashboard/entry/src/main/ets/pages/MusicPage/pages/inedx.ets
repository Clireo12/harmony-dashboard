import { Header } from '../pages/Header';
import Player from '../pages/Player';
import Content from '../pages/Content';

@Component
@Entry
struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
      // 标题栏
      Header()
        .width('100%')
        .height('auto')

      // 歌单
      Content()
        .layoutWeight(1)
        .width('100%')
        .height('auto')

      // 播放控制栏
      Player()
        .width('100%')
        .height('auto')
        .backgroundColor('#fff') // 可根据需要调整背景色
    }
    .width('100%')
    .height('100%')

  }
}
