import { SongItem } from "../pages/MusicPage/pages/SongData"

export class SongInfo {
  song: SongItem = {
    id: 0, title: '歌曲名称', singer: '歌手', mark:  $r('app.string.page_show'),
    label: $r('app.string.page_show'), src: '',
    index: 0, lyric: ''
  }
  time: number = 0  // 播放时间
  duration: number = 0  // 音乐总时长

  // 重置数据
  reset() {
    this.song = {
      id: 0, title: '歌曲名称', singer: '歌手', mark:  $r('app.string.page_show'),
      label: $r('app.string.page_show'), src: '',
      index: 0, lyric: ''
    }
    this.time = 0
    this.duration = 0
  }
}