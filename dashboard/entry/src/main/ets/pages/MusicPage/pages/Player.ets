@Entry
@Component
export default struct Player {
  @StorageProp('fontSize') fontSize: number = 18;
  @State isPlaying: boolean = false;  //播放状态
  @State progress: number = 0.3;  //播放进度
  @State isLiked: boolean = false;

  //显示播放列表的状态，从StorageProp获取默认值为false
  @StorageProp('showPlaylist') showPlaylist: boolean = false;
  //显示评论的状态，从StorageProp获取默认值为false
  @StorageProp('showComments') showComments: boolean = false;

  build() {
    Row() {

      Column() {
        Row({space:4}) {
          Text('歌曲名字')
            .fontSize(this.fontSize)
            .fontWeight(FontWeight.Bold);
          Text('-')
            .fontSize(this.fontSize);
          Text('歌手名字')
            .fontSize(this.fontSize);
          Image($r('app.media.ic_vip'))
            .width(20)
            .height(20);
        }
        .width('100%')
        .height('50%');

        Row({space: 30}) {
          Image(this.isLiked ? $r('app.media.ic_like_filled') : $r('app.media.ic_collect'))
            .width(35)
            .height(35)
            .onClick(() => { this.isLiked = !this.isLiked; });

          Image($r('app.media.ic_comments'))
            .width(35)
            .height(35)
            .onClick(() => {
              AppStorage.Set('showComments', !this.showComments); //切换显示评论状态
              AppStorage.Set('showPlaylist', false); //关闭播放列表
            });
        }
        .width('100%')
        .height('50%');
      }
      .width('20%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10);

      Column() {
        Row({space:20}) {
          Row({space: 30}){
            Image($r('app.media.ic_prev'))
              .width(36)
              .height(36);

            Image(this.isPlaying ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
              .width(36)
              .height(36)
              .onClick(() => { this.isPlaying = !this.isPlaying; });

            Image($r('app.media.ic_next'))
              .width(36)
              .height(36)

          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 10 });

        Slider({
          value: this.progress * 100,
          min: 0,
          max: 100,
          style: SliderStyle.OutSet
        })
          .blockColor('#ff1948')
          .selectedColor('#ff1948')
          .trackThickness(4)
          .width('90%');
      }
      .width('65%')
      .height('100%')
      .justifyContent(FlexAlign.Center);

      Column() {
        Image($r('app.media.ic_music_list'))
          .width(35)
          .height(35)
          .fillColor(Color.Black)
          .onClick(() => {
            AppStorage.Set('showPlaylist', !this.showPlaylist);
            AppStorage.Set('showComments', false);
          });
      }
      .width('15%')
      .height('100%')
      .justifyContent(FlexAlign.Center);
    }
    .width('100%')
    .padding(8);
  }
}