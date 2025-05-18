import { songList } from '../pages/SongListData'; // 导入歌曲列表数据
import { SongDataSource } from '../pages/SongDataSource'; // 导入歌曲数据源类
import { SongItem } from '../pages/SongData'; // 导入歌曲项的数据结构
import common from '@ohos.app.ability.common'; // 导入应用上下文模块
import window from '@ohos.window'; // 导入窗口管理模块
import storage from '@ohos.data.storage'; // 导入本地存储模块（未使用）

@Entry // 标记组件为入口组件
@Component // 声明这是一个 ArkUI 组件
export default struct PlayList {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // 获取当前组件的应用上下文

  @StorageLink('currentBreakpoint') currentBreakpoint: string = 'sm'; // 使用 StorageLink 双向绑定全局存储中的 currentBreakpoint，默认值为 'lg'
  @StorageProp('fontSize') fontSize: number = 0; // 使用 StorageProp 单向绑定全局存储中的 fontSize，默认值为 0
  @State songList: SongItem[] = songList || []; // 定义一个状态变量 songList，初始化为导入的歌曲列表数据
  @Provide('coverHeight') coverHeight: number = 10; // 提供一个父级可共享的状态 coverHeight，默认值为 10

  @State screenWidth: number = 0; // 定义屏幕宽度的状态变量，默认值为 0
  @State screenHeight: number = 0; // 定义屏幕高度的状态变量，默认值为 0

  aboutToAppear() { // 生命周期方法，在组件即将显示时调用
    window.getLastWindow(this.context).then((win) => { // 获取当前窗口实例
      const initProperties = win.getWindowProperties(); // 获取窗口属性
      this.screenWidth = initProperties.windowRect.width; // 获取初始窗口宽度并赋值给 screenWidth
      this.screenHeight = initProperties.windowRect.height; // 获取初始窗口高度并赋值给 screenHeight

      // 监听窗口尺寸变化事件
      win.on('windowSizeChange', (data: window.Size) => {
        this.screenWidth = data.width; // 动态更新 screenWidth
        this.screenHeight = data.height; // 动态更新 screenHeight
        if (this.screenHeight >= 860) { // 如果屏幕高度大于等于 860，则设置断点为 'lg'
          this.currentBreakpoint = 'lg';
        } else { // 否则设置断点为 'sm'
          this.currentBreakpoint = 'sm';
        }
      });
    });
  }

  @Builder // 自定义构建器，用于渲染播放全部按钮
  PlayAll() {
    Row() { // 创建一行布局
      Image($r("app.media.ic_play_all")) // 显示播放全部图标
        .height(23) // 设置图标高度
        .width(23); // 设置图标宽度
      Text('播放全部(104)') // 显示文本“播放全部(104)”
        .maxLines(1) // 设置最大行数为 1
        .padding({ left: 10 }) // 设置左侧内边距
        .fontColor('#000000') // 设置字体颜色为黑色
        .fontSize(20); // 设置字体大小
      Blank(); // 添加空白占位符以填充剩余空间
      Image($r('app.media.ic_order_play')) // 显示顺序播放图标
        .width(24) // 设置图标宽度
        .height(24) // 设置图标高度
        .margin({ right: 16 }); // 设置右侧外边距
      Image($r('app.media.ic_sort_list')) // 显示排序图标
        .height(24) // 设置图标高度
        .width(24); // 设置图标宽度
    }
    .height(50) // 设置行的高度
    .width('100%') // 设置行的宽度为 100%
    .backgroundColor('#fff') // 设置背景颜色为白色
    .padding({ left: 12, right: 12, bottom: 0 }); // 设置内边距
  }

  @Builder // 自定义构建器，用于渲染歌曲项
  SongItem(title: string, label: Resource, singer: string) {
    Row() { // 创建一行布局
      Column() { // 创建一列布局
        Text(title) // 显示歌曲标题
          .fontColor('#000000') // 设置字体颜色为黑色
          .fontSize(18) // 设置字体大小
          .margin({ bottom: 0 }); // 设置底部外边距
        Row() { // 创建一行布局
          Image(label) // 显示标签图标
            .width(16) // 设置图标宽度
            .height(16) // 设置图标高度
            .margin({ right: 4 }); // 设置右侧外边距
          Text(singer) // 显示歌手名称
            .opacity(0.38) // 设置透明度
            .fontColor('#000000') // 设置字体颜色为黑色
            .fontSize(14); // 设置字体大小
        }
      }
      .alignItems(HorizontalAlign.Start); // 设置水平对齐方式为左对齐

      Blank(); // 添加空白占位符以填充剩余空间
      Image($r('app.media.ic_list_more')) // 显示更多操作图标
        .height(24) // 设置图标高度
        .width(24); // 设置图标宽度
    }
    .height(60) // 设置行的高度
    .margin({ top: 0, bottom: 0 }) // 设置顶部和底部外边距
    .margin({ left: 8, right: 8 }) // 设置左右外边距
    .width('98%'); // 设置行的宽度为 98%
  }

  build() { // 构建主界面
    Column() { // 创建一列布局
      // Text(`当前断点：${this.currentBreakpoint}`) // 显示当前断点信息（注释掉了）
      //   .fontColor('#ff0000') // 设置字体颜色为红色
      //   .fontSize(12); // 设置字体大小
      this.PlayAll(); // 调用 PlayAll 构建器渲染播放全部按钮
      Scroll() { // 创建滚动区域
        GridRow() { // 使用栅格系统包裹 List
          GridCol({ span: { sm: 12, lg: 12 } }) { // 定义栅格列，断点 sm 和 lg 都占用 12 列
            List() { // 创建列表
              LazyForEach(new SongDataSource(this.songList), (item: SongItem) => { // 使用懒加载遍历歌曲数据源
                ListItem() { // 渲染每个列表项
                  this.SongItem(item.title, item.label, item.singer); // 调用 SongItem 构建器渲染歌曲项
                }
              });
            }
            .lanes(this.currentBreakpoint === 'lg' ? 2 : 1) // 根据断点动态设置列数
            .width('100%'); // 设置列表宽度为 100%
          }
        }
        .height('100%') // 设置栅格系统的高度为 100%
        .width('100%'); // 设置栅格系统的宽度为 100%
      }
      .height('100%') // 设置滚动区域的高度为 100%
      .backgroundColor('#fff') // 设置滚动区域的背景颜色为白色
      .margin({ top: 0, bottom: this.currentBreakpoint === 'sm' ? this.coverHeight : 0 }); // 设置顶部和底部外边距
    }
    .padding({ top: 0, bottom: 0 }); // 设置列的内边距
  }
}