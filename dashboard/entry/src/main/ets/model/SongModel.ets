import { SongItem } from "../pages/MusicPage/pages/SongData"

@Observed
export class SongInfo {
  id: number = 0
  title: string = '歌曲名称'
  singer: string = '歌手'
  mark: Resource = $r('app.string.page_show')
  label: Resource = $r('app.string.page_show')
  src: string = ''
  lyric: string = ''
  time: number = 0  // 播放时间
  duration: number = 0  // 音乐总时长

  // 重置数据
  reset() {
    this.id = 0
    this.title = '歌曲名称'
    this.singer = '歌手'
    this.mark = $r('app.string.page_show')
    this.label = $r('app.string.page_show')
    this.src = ''
    this.lyric = ''
    this.time = 0
    this.duration = 0
  }
}