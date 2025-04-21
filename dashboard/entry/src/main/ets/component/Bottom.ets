import { router } from "@kit.ArkUI"

@Preview
@Component
export struct Bottom {
  // 组件属性定义
  @Prop mileage: number = 212 // 里程显示文本，默认值'212 km'
  @Prop activeTab: string = 'D'    // 当前选中标签，默认选中'D'
  @State progress: number = 0.7    // 进度条进度值(0-1)，默认0.7(70%)

  /**
   * 根据里程计算进度百分比
   * @returns 计算后的进度值(0-1之间)
   */
  private getMileageProgress(): number {
    // 计算进度比例(假设最大里程为300km)，不超过1
    return Math.min(this.mileage / 300, 1)
  }

  /**
   * 组件生命周期 - 即将出现时调用
   */
  aboutToAppear() {
    // 初始化时根据里程计算进度
    this.progress = this.getMileageProgress()
  }

  /**
   * 构建组件UI
   */
  build() {
    // 使用Stack布局实现底部固定定位
    Stack({ alignContent: Alignment.Bottom }) {
      // 主内容行
      Row() {
        // 左侧区域：包含进度条、里程和图标
        Row({ space: 10 }) {
          // 进度条背景
          Row() {
            // 进度条前景(实际进度部分)
            Row()
              .width(`${this.progress * 100}%`) // 根据progress值设置宽度
              .height(8)
              .backgroundColor('#ff6ef864')

          }
          .width(100)
          .height(10)
          .backgroundColor('#E5E5E5') // 灰色背景
          .margin({ right: 10 })   // 右侧间距10px

          // 里程文本显示
          Text(`${this.mileage} km`)
            .fontSize(22)          // 字体大小22px
            .fontWeight(FontWeight.Bold) // 加粗显示

          // 右侧图标
          Image($r("app.media.light_near")) // 使用资源路径引用图标
            .fillColor('#007AFF')      // 图标填充色(蓝色)
            .width(30)
            .height(30)
            .margin({ left: 50 })
        }
        .padding({ left: 70 })     // 左侧内边距70px
        .layoutWeight(1)          // 布局权重1
        .justifyContent(FlexAlign.Center) // 内容居中

        // 中间导航标签区域
        Row() {
          // 构建5个导航标签
          this.buildTab('P')  // 停车模式
          this.buildTab('D')  // 驾驶模式
          this.buildTab('R')  // 倒车模式
          this.buildTab('N')  // 空档模式
          this.buildTab('S')  // 运动模式
        }
        .layoutWeight(1)          // 布局权重1
        .justifyContent(FlexAlign.Center) // 标签居中排列

        // 右侧占位区域(保持布局平衡)
        Row(){
          Image($r('app.media.back')).width(30).height(30)
            .onClick(() => {
              // 点击事件：跳转到主页
              router.push({ url: 'pages/MainPage' });
            })
        }.layoutWeight(1)
      }
      .width('100%')
      .height(60)
      .backgroundColor(Color.Transparent)
      .alignItems(VerticalAlign.Center) // 垂直居中
    }
    .width('100%')
    .height(60)
  }

  /**
   * 构建单个导航标签
   * @param tabName 标签名称
   * @returns 构建好的标签组件
   */
  @Builder
  buildTab(tabName: string) {
    Column() {
      // 标签文本
      Text(tabName)
        .fontSize(22)
        .fontColor(this.activeTab === tabName
          ? $r('app.color.clicked') // 选中状态颜色(从资源文件获取)
          : $r('app.color.normal')) // 未选中状态颜色
        .margin({ bottom: 2 }) // 底部间距2px

      // 选中状态指示器
      if (this.activeTab === tabName) {
        Row()
          .width(20)
          .height(2)
          .backgroundColor('#007AFF')
          .margin({ top: 2 })   // 顶部间距2px
      }
    }
    .margin({ left: 15 })      // 标签左侧间距15px
    .onClick(() => {
      // 点击事件：切换当前选中标签
      this.activeTab = tabName
    })
  }
}