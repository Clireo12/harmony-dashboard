import { songList } from '../pages/SongListData'; // 导入歌曲列表数据
import { SongDataSource } from '../pages/SongDataSource'; // 导入歌曲数据源类
import { CommentItem, SongItem } from '../pages/SongData'; // 导入歌曲项的数据结构 LyricLine,
import common from '@ohos.app.ability.common'; // 导入应用上下文模块
import window from '@ohos.window'; // 导入窗口管理模块
import storage from '@ohos.data.storage'; // 导入本地存储模块（未使用）
import { playerManager } from '../PlayerManager';

@Entry
@Component
export default struct PlayList {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // 获取当前组件的应用上下文
  @State songList: SongItem[] = songList || [];
  @StorageProp('fontSize') fontSize: number = 16;

  @Builder
  PlayAll() {
    Row() {
      Text('播放列表')
        .maxLines(1)
        .padding({ left: 8 })
        .fontColor('#000000')
        .fontSize(this.fontSize+1);
      Blank();
      Image($r('app.media.ic_order_play'))
        .width(24)
        .height(24)
        .margin({ right: 16 });
      Image($r('app.media.ic_sort_list'))
        .height(24)
        .width(24);
    }
    .height(50)
    .width('100%')
    .borderRadius(15)
    .backgroundColor('#fff')
    .padding({ left: 12, right: 12, bottom: 0 });
  }

  @Builder
  SongItem(title: string, label: Resource, singer: string) {
    Row() {
      Column() {
        Text(title)
          .fontColor('#000000')
          .fontSize(this.fontSize + 2)
          .margin({ bottom: 0 });
        Row() {
          Image(label)
            .width(16)
            .height(16)
            .margin({ right: 4 });
          Text(singer)
            .opacity(0.38)
            .fontColor('#000000')
            .fontSize(this.fontSize - 2);
        }
      }
      .alignItems(HorizontalAlign.Start);

      Blank();
      Image($r('app.media.ic_list_more'))
        .height(24)
        .width(24);
    }
    .height(60)
    .margin({ top: 0, bottom: 0 })
    .margin({ left: 8, right: 8 })
    .width('98%');
  }

  build() {
    Column() {
      this.PlayAll();

      Scroll() {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
          LazyForEach(new SongDataSource(this.songList), (item: SongItem, index: number) => {
            ListItem() {
              this.SongItem(item.title, item.label, item.singer);
            }
            .onClick(()=>{
              playerManager.play(playerManager.playList[index]);
            })
            .width('49%')
            .margin({ bottom: 8 })
          });

        }
        .width('100%')
      }
      .width('100%')
      .height('85%')
    }
    .width('100%')
    .height('100%')
    .borderRadius(20)
    .backgroundColor('#fff')
    .padding({ top: 0, bottom: 0 });
  }

}