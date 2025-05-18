import { OptionItem, optionList } from '../pages/SongListData'
@Entry
@Component

export default struct PlayListCover {
  @State imgHeight: number = 0;
  @StorageProp('coverMargin') coverMargin: number = 0;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @StorageProp('fontSize') fontSize: number = 0;
  @Provide('coverHeight') coverHeight: number = 100; // 设置默认值为 100

  @Builder
  CoverImage() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image($r('app.media.ic_album'))
        .width('100%')
        .aspectRatio(1)
        .borderRadius(8)
        .onAreaChange((oldArea: Area, newArea: Area) => {
          this.imgHeight = newArea.height as number
        })
        .margin({left:6})
      Text('12.5万')
        .letterSpacing(1)
        .fontColor('#fff')
        .fontSize(this.fontSize - 4)
        .translate({ x: 10, y: '-100%' })
        .margin({left:10})
    }
    .width('100%')
    // .height('100%')
    .aspectRatio(1)
    .margin({ top: 0 }); // 确保顶部 margin 为 0
  }

  @Builder
  CoverIntroduction() {
    Column() {
      Text('Suki')
        .opacity(0.9)
        .fontWeight(500)
        .fontColor('#556B89')
        .fontSize(20)
        .margin({ bottom: 4 })

      Text('我喜欢的音乐')
        .opacity(0.6)
        .width('100%')
        .fontWeight(400)
        .fontColor('#556B89')
        .fontSize(this.fontSize - 4)
    }
    .width('100%')
    // .height()
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .padding({ left: this.currentBreakpoint === 'sm' ? 20 : 0 })
    .margin({
      top: this.currentBreakpoint === 'sm' ? 20 : 40,
      bottom: this.currentBreakpoint === 'sm' ? 0 : 20
    })
  }

  @Builder
  CoverOptions() {
    Row() {
      ForEach(optionList, (item:OptionItem) => {
        Column({ space: 4 }) {
          Image(item.image).height(30).width(30)
          Text(item.text)
            .fontColor('#556B89')
            .fontSize(this.fontSize - 1)
        }
      })
    }
    .width('100%')
    .height(70)
    .padding({
      left: this.currentBreakpoint === 'sm' ? 20 : 0,
      right: this.currentBreakpoint === 'sm' ? 20 : 0
    })
    .margin({
      top: this.currentBreakpoint === 'sm' ? 10 : 0,
      bottom: this.currentBreakpoint === 'sm' ? 15 : 0
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }
  build() {
    Column() {
      // 借助栅格组件实现总体布局
      GridRow() {
        // 歌单图片
        GridCol({ span: { sm: 4, md: 10 }, offset: { sm: 0, md: 1, lg: 1 } }) {
          this.CoverImage()
        }

        // 歌单介绍
        GridCol({ span: { sm: 8, md: 10 }, offset: { sm: 0, md: 2, lg: 2 } }) {
          this.CoverIntroduction()
        }

        // 歌单操作
        GridCol({ span: { sm: 12, md: 10 }, offset: { sm: 0, md: 2, lg: 2 } }) {
          this.CoverOptions()
        }.margin({
          top: this.currentBreakpoint === 'sm' ? 15 : 0,
          bottom: this.currentBreakpoint === 'sm' ? 15 : 0
        })
      }
      .margin({ left: this.coverMargin, right: this.coverMargin, bottom:0 }); // 确保顶部 margin 为 0
    }
    .padding({ top: 0 }) // 将顶部 padding 调整为 0
    .backgroundColor('#ffe0e9f1')
    // .height('100%')
  }

}