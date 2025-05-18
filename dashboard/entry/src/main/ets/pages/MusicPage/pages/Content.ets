import PlayListCover from '../pages/PlayListCover';
import App from '../pages/PlayList';

@Entry
@Component
export default struct Content {

  build() {
    GridRow() {
      // 歌单封面
      GridCol({ span: { xs: 12, sm: 12, md: 6, lg: 4 } }) {
        PlayListCover()
      }

      // 歌单列表
      GridCol({ span: { xs: 12, sm: 12, md: 6, lg: 8 } }) {
        App()
      }
      // .height('100%')
    }
    .height('100%')

    .backgroundColor('#ffe0e9f1')
  }
}
