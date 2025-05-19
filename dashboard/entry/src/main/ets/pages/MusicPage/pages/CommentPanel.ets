import { CommentItem } from "./SongData";

@Component
export struct CommentPanel {
  @State comments: CommentItem[] = [
    {id: 1, username: "用户1", content: "这首歌真好听！", time: "10:30"},
    {id: 2, username: "用户2", content: "单曲循环中~", time: "11:15"}
  ];

  build() {
    Column() {
      Text('评论')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 15, bottom: 10 });

      Scroll() {
        Column() {
          ForEach(this.comments, (item: CommentItem) => {
            Column() {
              Row() {
                Text(item.username)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold);
                Text(item.time)
                  .fontSize(12)
                  .opacity(0.6)
                  .margin({ left: 10 });
              }
              Text(item.content)
                .fontSize(14)
                .margin({ top: 5, bottom: 15 });
            }
            .width('100%')
          })
        }
        .padding(15)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .borderRadius(15)
    .backgroundColor('#fff')
  }
}

