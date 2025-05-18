@Entry
@Component
export default struct Player {
  @StorageProp('fontSize') fontSize: number = 0;
  build() {

    Row() {
      Image($r('app.media.ic_album')).height(32).width(32).margin({right: 12})
      Column() {
        Text($r('app.string.song_name'))
          .fontColor('#000000')
          .fontSize(this.fontSize - 1)
        Row() {
          Image($r('app.media.ic_vip'))
            .height(16)
            .width(16)
            .margin({ right: 4 })
          Text($r('app.string.singer'))
            .fontColor('#000000')
            .fontSize(this.fontSize - 4)
            .opacity(0.38)
        }
      }
      .alignItems(HorizontalAlign.Start)
      // 通过Blank组件实现拉伸能力
      Blank()
      Image($r('app.media.ic_play')).height(26).width(26).margin({right: 16})
      Image($r('app.media.ic_next')).height(24).width(24).margin({right: 16})
      Image($r('app.media.ic_music_list')).height(24).width(24)
    }
    .width('100%')
    .height(48)
    .backgroundColor('#ffeaf0f5')
    .alignItems(VerticalAlign.Center)
    .padding({left: 16, right: 16})
    .margin({bottom: 0}) // 确保底部间距为0

  }
}