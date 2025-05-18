@Component
export struct Header {
  @State moreBackgroundColor: string ='#8ae0e9f1';
  build() {
    GridRow() {
      GridCol({span: {sm:6, md: 6, lg:4}}) {
        Row() {
          Image($r('app.media.ic_back')).height('24vp').width('24vp')
          Text('歌单').fontSize(20).padding({left:10})
        }
        .width('100%')
        .height('40vp')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .padding({left:10})
        .backgroundColor('#ffe0e9f1')
      }
      GridCol({span: {sm:6, md: 6, lg:8}}) {
        Row() {
          Image($r('app.media.ic_more')).height('24vp').width('24vp')
        }
        .width('100%')
        .height('40vp')
        .justifyContent(FlexAlign.End)
        .alignItems(VerticalAlign.Center)
        .padding({right:10})
        .backgroundColor(this.moreBackgroundColor)
      }
    }.onBreakpointChange((currentBreakpoint) => {
      // 调整不同断点下返回按钮及歌单的背景色
      if (currentBreakpoint === 'sm') {
        this.moreBackgroundColor = '#ffe0e9f1';
      } else {
        this.moreBackgroundColor = '#ffeaf0f5';
      }
    }).width('100%').backgroundColor('#ffe0e9f1')
  }
}