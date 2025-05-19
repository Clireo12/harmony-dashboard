import PlayListCover from '../pages/PlayListCover';
import App from '../pages/PlayList';
import { Album } from './Album';
import { CommentPanel } from '../pages/CommentPanel';
import PlayList from '../pages/PlayList';

//定义歌词行接口
interface LyricLine {
  id: number;
  text: string;
}

//定义评论项接口
interface CommentItem {
  id: number;
  username: string;
  content: string;
  time: string;
}

//初始化歌词行数据
const initialLyricLines: LyricLine[] = [
  { id: 1, text: "第一行歌词" },
  { id: 2, text: "第二行歌词" }
];

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

  @State lyricLines: LyricLine[] = initialLyricLines;
  @State comments: CommentItem[] = initialComments;
  @State mainContentWidth: string = '100%';

  @State panelOffset: number = 100; //偏移量
  @State currentAlbumIndex: number = 0  //当前专辑索引

  @State albums: Resource[] = [
    $r('app.media.ic_avatar1'),
    $r('app.media.ic_avatar2'),
    $r('app.media.ic_avatar3')
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
            .width('75%')
            .margin({ right: 20 })
        }
        .width(this.showPlaylist || this.showComments ? '45%' : '50%')
        .justifyContent(FlexAlign.Center)

        Column() {
          Text('歌曲名字')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 });

          Row() {
            Image($r('app.media.ic_vip'))
              .height(16)
              .width(16)
              .margin({ right: 5 });
            Text('歌手名字')
              .fontSize(16);
          }
          .margin({ bottom: 12 });

          Scroll() {
            Column() {
              ForEach(this.lyricLines, (item: LyricLine) => {
                Text(item.text)
                  .fontSize(14)
                  .margin({ bottom: 10 });
              })
            }
            .padding(8)
          }
          .height('70%')
        }
        .width(this.showPlaylist || this.showComments ? '55%' : '50%')
      }
      .width(this.showPlaylist || this.showComments ? '70%' : '80%')
      .height('100%')
      .position({
        x: this.showPlaylist || this.showComments ? '0%' : '10%'
      })
      .animation({
        duration: 200,
        curve: Curve.EaseOut
      })

      Column() {
        if (this.showPlaylist) {
          PlayList()
        }
        if (this.showComments) {
          CommentPanel()
        }
      }
      .width('30%')
      .height('100%')
      .position({
        x: this.showPlaylist || this.showComments ? '70%' : '100%'
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