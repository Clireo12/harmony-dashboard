/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// import { RouterUrlConstants } from '@ohos/constantsCommon';
import { SongItem } from '../pages/SongData';

const songList: SongItem[] = [
  { id: 0, title: '背对背拥抱', singer: '林俊杰', mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_dream'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=c3Nta3hr&k=320kmp3', // https://joy127.jstools.net/uploads/mp3/202505/30/1123683924a864458960177.mp3
    index: 0, lyric: '' },

  { id: 1, title: 'Nobody', singer: 'Wonder Girls', mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_dream'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=eGt2a2hoeHM&k=320kmp3', index:0,
    lyric: 'lrcfiles/DreamItPossible.lrc' },

  { id: 2, title: '逆战', singer: '张杰', mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar2'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=d3h2c3dkeHZt&k=320kmp3', index:1, lyric: '' },

  { id: 3, title: '同桌的你', singer: '老狼', mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar16'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=d2tkbWhtYw&k=320kmp3', index:2, lyric: '' },

  { id: 4, title: '喜欢你', singer: 'G.E.M. 邓紫棋', mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar4'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=dm14dndkaw&k=320kmp3' , index:3, lyric: ''},

  { id: 5, title: 'Love Story', singer: 'Taylor Swift', mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar5'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=dnN4ZGNtaGQ&k=320kmp3', index:4, lyric: '' },

  { id: 6, title: '等一分钟', singer: '徐誉滕', mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar6'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=ZHdjY3Nj&k=320kmp3' , index:5, lyric: ''},

  { id: 7, title: '你瞒我瞒', singer: '陈柏宇', mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar17'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=Y21jbXNo&k=320kmp3', index:6, lyric: '' },

  { id: 8, title: '淘汰', singer: '陈奕迅', mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar8'), src: 'https://www.2t58.com/plug/down.php?ac=music&id=bWRjY2hu&k=320kmp3', index:7, lyric: '' },
  //
  // { id: 9, title: 'Call Me Now', singer: 'Michael Calfan、INNA', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar9'), src: 'https://lv-sycdn.kuwo.cn/df1a5d6f81f3228e4bdbcf1eb89bbb67/683d51f7/resource/30106/trackmedia/M500001QfJy13xbK3m.mp3', index:8, lyric: '' },
  //
  // { id: 10, title: '说好的幸福呢', singer: '周杰伦', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar10'), src: 'https://lu-sycdn.kuwo.cn/36c03b96040627dfdaf97e027db67b9e/683d521f/resource/a3/71/38/1493491850.aac', index:9, lyric: '' },
  //
  // { id: 11, title: '当你', singer: '林俊杰', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar11'), src: 'https://er-sycdn.kuwo.cn/4105703fe44ece52c72a37735888ed33/683d5412/resource/30106/trackmedia/M500001nUzRq0GgCVb.mp3', index:10, lyric: '' },
  //
  // { id: 12, title: '我是谁', singer: '小碗你好', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar12'), src: 'world.wav', index:11, lyric: '' },
  //
  // { id: 13, title: '你好吗', singer: '张三-你好我好都好', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar13'), src: 'power.wav', index:12, lyric: '' },
  //
  // { id: 14, title: '你在哪', singer: '不知道你是谁', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar14'), src: 'power.wav', index:13, lyric: '' },
  //
  // { id: 15, title: 'lovely', singer: 'Gwyu-Hjjiyabn', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar15'), src: 'world.wav', index:14, lyric: '' },
  //
  // { id: 16, title: '谢谢你', singer: '名佚', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar16'), src: 'boisterous.wav', index:15, lyric: '' },
  //
  // { id: 17, title: '我是靓仔', singer: '我是小树', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar17'), src: 'world.wav', index:16, lyric: '' },
  //
  // { id: 18, title: '听我说', singer: '全村最帅', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar1'), src: 'power.wav', index:17, lyric: '' },
  //
  // { id: 19, title: '没什么大不了', singer: '小安安', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar2'), src: 'power.wav', index:18, lyric: '' },
  //
  // { id: 20, title: '其实也一样', singer: '我是小树', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar13'), src: 'world.wav', index:19, lyric: '' },
  //
  // { id: 21, title: '想明白', singer: '小安安', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar4'), src: 'boisterous.wav', index:20, lyric: '' },
  //
  // { id: 22, title: '你懂的', singer: '小安安', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar5'), src: 'world.wav', index:21, lyric: '' },
  //
  // { id: 23, title: '谁了解', singer: '小安安', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar6'), src: 'power.wav', index:22, lyric: '' },
  //
  // { id: 24, title: '白天', singer: '小安安', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar17'), src: 'power.wav', index:23, lyric: '' },
  //
  // { id: 25, title: '黑夜', singer: 'Gwyu-Hjjiyabn', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar15'), src: 'world.wav', index:24, lyric: '' },
  //
  // { id: 26, title: '春夏秋冬', singer: '名佚', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar16'), src: 'boisterous.wav', index:25, lyric: '' },
  //
  // { id: 27, title: '一年四季', singer: '我是小树', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar17'), src: 'world.wav', index:26, lyric: '' },
  //
  // { id: 28, title: '朝雪', singer: '全村最帅', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar12'), src: 'power.wav', index:27, lyric: '' },
  //
  // { id: 29, title: '暮色', singer: '小安安', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar13'), src: 'power.wav', index:28, lyric: '' },
  //
  // { id: 30, title: '天下', singer: '我是小树', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar14'), src: 'world.wav', index:29, lyric: '' },
  //
  // { id: 31, title: '爱爱爱', singer: '方大同', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar15'), src: 'https://lu-sycdn.kuwo.cn/91ee92412098aca438123a823ab6a523/683d534f/resource/a3/62/97/2479394519.aac', index:30, lyric: '' },
  //
  // { id: 32, title: '天天', singer: '陶喆', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar16'), src: 'https://lx-sycdn.kuwo.cn/b4002a333803ebddad9f4e59beb514e2/683d52c6/resource/a3/51/24/2675190733.aac', index:31, lyric: '' },
  //
  // { id: 33, title: '就是现在', singer: '王力宏', mark: $r('app.media.ic_vip'),
  //   label: $r('app.media.ic_avatar17'), src: 'https://lu-sycdn.kuwo.cn/0fc7cbddbf93fcb8e70c9c6da6c8f882/683d5279/resource/a3/83/90/1124672540.aac', index:32, lyric: '' },
  //
  // { id: 34, title: '春风吹', singer: '方大同', mark: $r('app.media.ic_sq'),
  //   label: $r('app.media.ic_avatar11'), src: 'https://lu-sycdn.kuwo.cn/ce274b04ac744b60e9d8043b9f58c424/683d5257/resource/a1/39/86/3295871277.aac', index:33, lyric: '' }
]

const optionList : OptionItem[] = [
  { image: $r('app.media.ic_collect'), text: '收藏' },
  { image: $r('app.media.ic_download'), text: '下载' },
  { image: $r('app.media.ic_comments'), text: '评论'},
  { image: $r('app.media.ic_share'), text: '分享' }
]

class OptionItem {
  image: Resource = $r('app.media.ic_collect');
  text?: string;
  action?: (pageIndexInfos: NavPathStack) => void;
}

export { optionList, OptionItem, songList}