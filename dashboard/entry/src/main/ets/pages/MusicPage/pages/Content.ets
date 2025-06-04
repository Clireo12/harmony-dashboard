import PlayListCover from '../pages/PlayListCover';
import App from '../pages/PlayList';
import { Album } from './Album';
import { CommentPanel } from '../pages/CommentPanel';
import PlayList from '../pages/PlayList';
import { playerManager } from '../PlayerManager';
import { CommentItem, LyricLine } from './SongData';
import { SongInfo } from '../../../model/SongModel';

//初始化评论数据
const initialComments: CommentItem[] = [
  { id: 1, username: "User 1", content: "This is comment number 1", time: "10:00" }
];

@Entry
@Component
export default struct Content {
  //显示播放列表状态
  @StorageLink('showPlaylist') showPlaylist: boolean = false;
  //显示评论面板状态
  @StorageLink('showComments') showComments: boolean = false;
  @StorageLink('currentSong') currentSong: SongInfo = playerManager.currentSong

  @State comments: CommentItem[] = initialComments;
  @State mainContentWidth: string = '100%';

  @State panelOffset: number = 100; //偏移量
  @State currentAlbumIndex: number = 0  //当前专辑索引

  @State albums: Resource[] = [
    $r('app.media.ic_dream'),
    $r('app.media.ic_avatar5'),
    $r('app.media.ic_avatar2'),
    $r('app.media.ic_avatar17'),
    $r('app.media.ic_avatar4'),
  ];

  aboutToUpdate() {
    if (this.showPlaylist || this.showComments) {
      this.mainContentWidth = '60%';
      this.panelOffset = 0;
    } else {
      this.mainContentWidth = '100%';
      this.panelOffset = 100;
    }
  }

  build() {
    Stack() {
      Row() {
        Column(){
          //专辑封面
          Album({
            albums: this.albums,
            currentIndex: this.currentAlbumIndex,
            onSwipe: (index: number) => {
              this.currentAlbumIndex = index;
            }
          })
            .width('65%')
            .margin({ right: 10 })
        }
        .width(this.showComments ? '45%' : '50%')
        .justifyContent(FlexAlign.Center)

        // 播放列表
        Column() {
          PlayList()
            .height('95%')
        }
        .width(this.showComments ? '55%' : '50%')
      }
      .width( this.showComments ? '70%' : '80%')
      .height('100%')
      .position({
        x: this.showComments ? '0%' : '10%'
      })
      .animation({
        duration: 200,
        curve: Curve.EaseOut
      })

      Column() {
        // if (this.showPlaylist) {
        //   PlayList()
        // }
        if (this.showComments) {
          CommentPanel()
        }
      }
      .width('30%')
      .height('100%')
      .position({
        x:  this.showComments ? '72%' : '100%'
      })
      .animation({
        duration: 200,
        curve: Curve.EaseOut
      })
    }
    .height('100%')
    .onClick(() => {
      //空白区域时关闭评论或歌单
      if (this.showPlaylist || this.showComments) {
        this.showPlaylist = false;
        this.showComments = false;
      }
    })
  }
}