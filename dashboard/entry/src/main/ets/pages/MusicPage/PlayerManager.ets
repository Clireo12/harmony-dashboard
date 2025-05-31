import { media } from '@kit.MediaKit'
import { SongInfo } from '../../model/SongModel'
import { SongItem } from './pages/SongData'
import { songList } from './pages/SongListData'

@Observed
class PlayerManager {
  player: media.AVPlayer | null = null // 播放器
  isPlay: boolean = false // 播放、暂停
  currentSong: SongInfo = new SongInfo() // 当前播放歌曲
  playIndex: number = 0 // 当前播放索引
  playList: SongItem[] = songList || [] // 播放列表

  // 创建播放器
  async init() {
    if (!this.player) {
      this.player = await media.createAVPlayer()
    }

    // 监听状态
    this.player.on('stateChange', (state) => {
      switch (state) {
        case 'initialized':
          this.player?.prepare()
          this.setCurrentSong(this.playList[0])
          this.player!.url = this.currentSong.src
          break
        case 'prepared':
          this.player?.play()
          this.isPlay = true
          break
        case 'completed':
          this.next() // 自动播放下一首
          break
        case 'released':
          this.currentSong.reset()
          break
      }
    })

    // 监听时间变化
    this.player.on('durationUpdate', (duration) => {
      this.currentSong.duration = duration
    })
    this.player.on('timeUpdate', (time) => {
      this.currentSong.time = time
    })

    AppStorage.setOrCreate('isPlay', this.isPlay);
    AppStorage.setOrCreate('currentSong', this.currentSong);
  }

  // 销毁播放器
  async destroy() {
    await this.player?.release()
  }

  setCurrentSong(song: SongItem) {
    this.currentSong.id = song.id
    this.currentSong.title = song.title
    this.currentSong.singer = song.singer
    this.currentSong.mark = song.mark
    this.currentSong.label = song.label
    this.currentSong.src = song.src
    this.currentSong.lyric = song.lyric
  }

  // 播放歌曲
  play(song: SongItem = this.playList[0]) {
    // 正在播放
    if (this.currentSong.src === song.src) {
      this.player?.play()
      this.isPlay = true
      return
    }
    // 修改正在播放的歌曲
    else {
      this.playIndex = this.playList.findIndex(item => item.id === song.id)
    }
    this.changeSong()
  }

  // 切换歌曲
  async changeSong() {
    await this.player?.reset()
    const song = this.playList[this.playIndex]
    this.currentSong.time = 0
    this.currentSong.duration = 0
    this.setCurrentSong(song)
    this.player!.url = song.src
  }

  // 跳转进度
  skip(value: number) {
    this.player?.seek(value)
  }

  // 暂停播放
  paused() {
    this.player?.pause()
    this.isPlay = false
  }

  // 上一首
  prev() {
    if (this.playIndex - 1 < 0) {
      this.playIndex = this.playList.length - 1
    } else {
      this.playIndex--
    }
    this.play(this.playList[this.playIndex])
  }

  // 下一首
  next() {
    if (this.playIndex + 1 >= this.playList.length) {
      this.playIndex = 0
    } else {
      this.playIndex++
    }
    this.play(this.playList[this.playIndex])
  }
}

export const playerManager: PlayerManager = new PlayerManager()