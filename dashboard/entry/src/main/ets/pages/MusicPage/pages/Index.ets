import Player from '../pages/Player';
import Content from '../pages/Content';
import { router } from '@kit.ArkUI';

@Component
@Entry
struct Index {
  build() {
    Column() {

      Column() {
        Row() {
          Image($r("app.media.back"))
            .width(40)
            .fillColor(Color.Black)
            .onClick(() => {
              //跳转到主页
              router.back({
                url: 'pages/MainPage'
              })
            })
            .margin({ left: 30 })
        }
        .width('100%')
        .height(30)
        .margin({ top: 20 })
        .justifyContent(FlexAlign.Start)
      }
      .height('10%')

      Content()
        .width('100%')
        .height('70%')

      Player()
        .width('100%')
        .height('20%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffe0e9f1')
  }
}