// 定义主题键类型，用于标识不同的主题
type ThemeKey = 'custom' | 'tech-blue' | 'minimal-white' | 'classic-blackRed';

// 主题配置接口，定义了每个主题的配置项
interface ThemeConfig {
  bg: Resource; // 背景图片资源
  mask: ResourceColor; // 蒙版颜色
  textColor: ResourceColor; // 文字颜色
  iconColor: ResourceColor; // 图标颜色
  buttonIcon: Resource; // 按钮图标资源
}


@Entry
@Component
struct PersonalizationSettings {
  // 状态变量
  @State currentTheme: ThemeKey = 'custom'; // 当前选中的主题，默认为 'custom'
  @State brightnessValue: number = 0.5; // 亮度值，初始为 50%

  // 主题配置，定义了每个主题的具体配置
  private themeConfig: Record<ThemeKey, ThemeConfig> = {
    'custom': {
      bg: $r('app.media.bg_minimal_white'), // 背景图片
      mask: $r('app.color.theme_white'), // 蒙版颜色
      textColor: $r('app.color.theme_black'), // 文字颜色
      iconColor: $r('app.color.theme_black'), // 图标颜色
      buttonIcon: $r('app.media.bg_minimal_white') // 按钮图标
    },
    'tech-blue': {
      bg: $r('app.media.bg_tech_blue'),
      mask: $r('app.color.theme_blue'),
      textColor: $r('app.color.theme_white'),
      iconColor: $r('app.color.theme_white'),
      buttonIcon: $r('app.media.bg_tech_blue')
    },
    'minimal-white': {
      bg: $r('app.media.bg_minimal_white'),
      mask: $r('app.color.theme_white'),
      textColor: $r('app.color.theme_black'),
      iconColor: $r('app.color.theme_black'),
      buttonIcon: $r('app.media.bg_minimal_white')
    },
    'classic-blackRed': {
      bg: $r('app.media.bg_classic_blackRed'),
      mask: $r('app.color.theme_black'),
      textColor: $r('app.color.theme_white'),
      iconColor: $r('app.color.theme_white'),
      buttonIcon: $r('app.media.bg_classic_blackRed')
    }
  };

  // 当前主题配置，根据当前主题获取对应的配置
  @State currentConfig: ThemeConfig = this.themeConfig[this.currentTheme];

  build() {
    Stack() {
      // 背景层，用于显示当前主题的背景图片
      if (this.currentConfig.bg) {
        Image(this.currentConfig.bg)
          .width('100%')
          .height('100%'); // 背景图片铺满整个屏幕
      }

      // 控制面板，包含主题切换和亮度调节区域
      Row() {
        // 左侧：主题切换和亮度调节区域
        Column() {
          // 主题切换区域
          Column() {
            // 主题切换标题
            Text('主题切换')
              .fontSize(20)
              .fontColor(this.currentConfig.textColor)
              .textAlign(TextAlign.Center)
              .margin({ bottom: 20 });

            // 主题切换按钮
            Row() {
              this.buildThemeButton('classic-blackRed', '经典红黑'); // 经典红黑主题按钮
              this.buildThemeButton('tech-blue', '科技蓝'); // 科技蓝主题按钮
              this.buildThemeButton('minimal-white', '极简白'); // 极简白主题按钮
              this.buildThemeButton('custom', '自定义'); // 自定义主题按钮
            }
            .justifyContent(FlexAlign.SpaceEvenly)  // 均匀分配空间
            .width('100%')  // 确保填满父容器
            .margin({ bottom: 40 });
          }
          .width('100%')
          .backgroundColor(this.currentConfig.mask) // 背景颜色随主题切换
          .borderRadius(10) // 圆角
          .margin({ bottom: 20 }); // 底部外边距

          // 亮度调节区域
          Column() {
            Text('亮度调节') // 亮度调节标题
              .fontSize(20)
              .fontColor(this.currentConfig.textColor)
              .textAlign(TextAlign.Center)
              .margin({ bottom: 20 });

            //滑块和图标
            Row() {
              this.buildBrightnessIcon('left'); // 左侧亮度图标
              this.buildBrightnessSlider(); // 亮度滑块
              this.buildBrightnessIcon('right'); // 右侧亮度图标
            }
            .justifyContent(FlexAlign.SpaceEvenly) // 图标和滑块水平均匀分布
            .width('100%')


            //滑块刻度
            Row() {
              ForEach([0, 20, 40, 60, 80, 100], (value: number) => {
                Text(value.toString()) // 亮度刻度数字
                  .fontColor(this.currentConfig.textColor)
                  .width('10%')
                  .textAlign(
                    value === 0 ? TextAlign.Start :
                      value === 100 ? TextAlign.End :
                      TextAlign.Center
                  );
              })
            }
            .justifyContent(FlexAlign.SpaceEvenly) // 数字水平均匀分布
            .width('90%'); // 与滑块宽度一致
          }
          .width('100%')
          .padding({ bottom: 15 })
          .justifyContent(FlexAlign.SpaceEvenly)
          .backgroundColor(this.currentConfig.mask) // 背景颜色随主题切换
          .borderRadius(10); // 圆角
        }
        .width('50%') // 左侧区域宽度设置为 50%
        .padding({ left: 30 }) // 左侧内边距

        // 右侧：其他组件区域
        Column() {
          // 可以在这里放置其他组件
          Text('其他组件') // 右侧标题
            .fontSize(20)
            .fontColor(this.currentConfig.textColor)
            .textAlign(TextAlign.Center)
            .margin({ bottom: 20 });

          // 示例：空的 Row 占位
          Row() {
            Text('右侧内容1') // 右侧内容示例
              .fontColor(this.currentConfig.textColor)
              .margin({ right: 20 });
            Text('右侧内容2')
              .fontColor(this.currentConfig.textColor);
          }
        }
        .width('50%') // 右侧区域宽度设置为 50%
        .padding({ left: 30 }); // 右侧内边距
      }
      .width('100%')
      .height('100%');
    }
    .width('100%')
    .height('100%');
  }

  /**
   * 构建主题切换按钮
   * @param theme 当前主题键
   * @param label 按钮显示的标签
   */
  @Builder
  buildThemeButton(theme: ThemeKey, label: string) {
    Column() {
      Image(this.themeConfig[theme].buttonIcon) // 主题按钮图标
        .width(80)
        .height(80)
        .borderRadius(40) // 圆形按钮
        .backgroundColor(this.currentConfig.textColor)
        .onClick(() => {
          this.changeTheme(theme); // 切换主题
        });

      Text(label) // 主题按钮文字
        .fontSize(14)
        .fontColor(this.currentConfig.textColor)
        .textAlign(TextAlign.Center)
        .margin({ top: 10 });
    }
  }

  /**
   * 构建亮度图标
   * @param position 图标位置，'left' 或 'right'
   */
  @Builder
  buildBrightnessIcon(position: 'left' | 'right') {
    Image(position === 'left' ? $r('app.media.sun_left') : $r('app.media.sun_right')) // 亮度图标
      .width(24)
      .height(24)
      .fillColor(this.currentConfig.iconColor);
  }

  /**
   * 构建亮度调节滑块
   */
  @Builder
  buildBrightnessSlider() {
    Slider({
      value: this.brightnessValue * 100, // 当前亮度值
      min: 0, // 最小值
      max: 100, // 最大值
      step: 10, // 步长
      style: SliderStyle.InSet // 滑块样式
    })
      .trackThickness(20) // 轨道厚度
      .showSteps(true) // 显示刻度
      .showTips(true) // 显示提示
      .width('90%') // 滑块宽度
      .onChange((value: number) => {
        this.brightnessValue = value / 100; // 更新亮度值
      });
  }

  /**
   * 切换主题
   * @param theme 新的主题键
   */
  private changeTheme(theme: ThemeKey) {
    this.currentTheme = theme; // 更新当前主题
    this.currentConfig = this.themeConfig[theme]; // 更新当前主题配置
  }
}