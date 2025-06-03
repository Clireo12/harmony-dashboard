import { SongInfo } from '../../../model/SongModel';
import IotDataTool from '../../../utils/IotDataTool';
import { playerManager } from '../PlayerManager'

@Entry
@Component
export default struct Player {
  @StorageLink('fontSize') fontSize: number = 18;
  @StorageLink('isPlay') isPlaying: boolean = false;  //播放状态
  @StorageLink('currentSong') currentSong: SongInfo = playerManager.currentSong
  @State progress: number = 0.3;  //播放进度
  @State isLiked: boolean = false;
  //显示播放列表的状态，从StorageProp获取默认值为false
  @StorageLink('showPlaylist') showPlaylist: boolean = false;
  //显示评论的状态，从StorageProp获取默认值为false
  @StorageLink('showComments') showComments: boolean = false;

  // 时间转换
  number2time(number: number) {
    return number > 60 * 1000 ? Math.floor(number/1000/60).toString().padStart(2, '0') + ':' + Math.floor(number/1000%60).toString().padStart(2, '0') : '00:' + Math.floor(number/1000%60).toString().padStart(2, '0')
  }

  build() {
    Row() {

      Column() {
        Row({space:4}) {
          Text(this.currentSong.title)
            .fontSize(this.fontSize)
            .fontWeight(FontWeight.Bold);
          Text('-')
            .fontSize(this.fontSize);
          Text(this.currentSong.title)
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
              .height(36)
              .onClick(() => {
                playerManager.prev()
              })

            Image(this.isPlaying ? $r('app.media.ic_play') : $r('app.media.ic_pause'))
              .width(36)
              .height(36)
              .onClick(() => {
                this.isPlaying = !this.isPlaying;
                if (this.isPlaying) {
                  playerManager.play()
                } else {
                  playerManager.paused()
                }
              });

            Image($r('app.media.ic_next'))
              .width(36)
              .height(36)
              .onClick(() => {
                playerManager.next()
              })
          }

          Blank()

          Text(`${this.number2time(this.currentSong.time)} / ${this.number2time(this.currentSong.duration)}`)
        }
        .padding({ left: 210, right: 50 })
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 10 });

        Slider({
          value: this.currentSong.time,
          min: 0,
          max: this.currentSong.duration,
          style: SliderStyle.OutSet
        })
          .blockColor('#ff1948')
          .selectedColor('#ff1948')
          .trackThickness(4)
          .width('90%')
          .onChange((value) => {
            playerManager.skip(value)
          })
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