// 引入 Header 组件
import { Header } from '../../component/Header';
//引入Bottom组件
import { Bottom } from '../../component/Bottom';

import { City } from '../../component/City';

//引入主题配置接口
import { themeConfig, ThemeConfig } from '../../model/ThemeConfig'

// 定义主题键类型，用于标识不同的主题
type ThemeKey = 'custom' | 'tech-blue' | 'minimal-white' | 'classic-blackRed';

// 定义偏好设置项的类型
interface PreferenceItem {
  name: string;       // 选项名称（如“相机灯显示屏”）
  enabled: boolean;    // 是否启用
}

@Entry
@Component
export struct PersonalizationSettings {
  // 状态变量
  @State currentTheme: ThemeKey = 'minimal-white'; // 当前选中的主题，默认为 'custom'
  @State brightnessValue: number = 0.5; // 亮度值，初始为 50%

  // 默认偏好设置配置
  private preferenceConfig: PreferenceItem[] = [
    { name: '转向灯提示音', enabled: false },
    { name: '驾驶模式切换音效', enabled: true },
    { name: '故障报警语音播报', enabled: false },
    { name: '仪表盘动画速度', enabled: true },
    { name: '方言识别模式', enabled: false },
    { name: '盲区监测提示', enabled: true },
    { name: '语音反馈模式', enabled: false },
  ];

  // 当前主题配置，根据当前主题获取对应的配置
  @State currentConfig: ThemeConfig = themeConfig[this.currentTheme];

  build() {
    Column(){
      // 添加 Header 组件
      Header()

      Stack() {

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
            .padding({ top: 20 })
            .width('80%')
            .backgroundColor(this.currentConfig.mask) // 背景颜色随主题切换
            .borderRadius(10) // 圆角
            .margin({ left : -100,bottom: 20 }); // 外边距

            // 亮度调节区域
            Column() {
              Text('亮度调节') // 亮度调节标题
                .fontSize(20)
                .fontColor(this.currentConfig.textColor)
                .textAlign(TextAlign.Center)
                .margin({ top: 10, bottom: 10 });

              //滑块和图标
              Row() {
                this.buildBrightnessIcon('left'); // 左侧亮度图标
                this.buildBrightnessSlider(); // 亮度滑块
                this.buildBrightnessIcon('right'); // 右侧亮度图标
              }
              .justifyContent(FlexAlign.SpaceEvenly) // 图标和滑块水平均匀分布
              .width('90%')

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
            .width('80%')
            .padding({ bottom: 15 })
            .justifyContent(FlexAlign.SpaceEvenly)
            .backgroundColor(this.currentConfig.mask) // 背景颜色随主题切换
            .margin({left : -100})// 外边距
            .borderRadius(10); // 圆角
          }
          .width('50%') // 左侧区域宽度设置为 50%
          .padding({ left: 30 }) // 左侧内边距
          .height(350)

          // 右侧
          Row() {
            //偏好设置
            Column(){
              Text('偏好设置')
                .width('100%')
                .fontSize(20)
                .fontColor(this.currentConfig.textColor)
                .textAlign(TextAlign.Center);

              // 动态渲染所有偏好设置项

              Column(){
                ForEach(this.preferenceConfig, (item: PreferenceItem, index) => {
                  Row(){
                    Text(item.name)
                      .fontSize(14)
                      .fontColor(this.currentConfig.textColor)
                      .layoutWeight(1)
                      .margin({left : 10});

                    // 按钮设置
                    Toggle({ type: ToggleType.Switch, isOn: item.enabled })
                      .margin({ right: 10 })
                      .width(30)  // 明确设置宽度
                      .height(20) // 明确设置高度
                      .onChange((isOn: boolean) => {
                        this.preferenceConfig[index].enabled = isOn;
                      })
                  }
                  .width('100%')
                  .height(40)
                  .margin({ bottom: 5 });
                })
              }
              .width('100%')
              .height("80%")  // 固定高度确保内容不超出
              .margin({ top: 5, bottom: 5 })

            }
            .width('45%')
            .backgroundColor(this.currentConfig.mask) // 背景颜色随主题切换
            .borderRadius(10) // 圆角
            .height(360) // 设置固定高度
            .padding(10) // 右侧内边距
            .margin({ left: -110, right: -30 }); // 添加左侧间隔

            //汽车图片
            Stack(){
              City()
              Image($r('app.media.car')).width(480).height(300)
            }
          }
          .width('50%') // 右侧区域宽度设置为 50%
          .height(330)
          .padding({ left: 30 }); // 右侧内边距

        }
        .width('100%')
        .height('100%');
      }
      .layoutWeight(1)

      // 添加 Bottom 组件
      Bottom()

    }
  }

  /**
   * 构建主题切换按钮
   * @param theme 当前主题键
   * @param label 按钮显示的标签
   */
  @Builder
  buildThemeButton(theme: ThemeKey, label: string) {
    Column() {
      Image(themeConfig[theme].buttonIcon) // 主题按钮图标
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

  // 构建单个偏好设置项的方法
  @Builder
  buildPreferenceItem(name: string, enabled: boolean) {
    Row() {
      Column() {
        Text(name) // 选项名称
          .fontSize(14)
          .fontColor(this.currentConfig.textColor)
          .textAlign(TextAlign.Start) // 文字左对齐
          .margin({ bottom: 5 }); // 调整间距
      }
      .layoutWeight(1) // 左侧文本占满剩余空间

      // Toggle 按钮样式调整
      Toggle({ type: ToggleType.Switch, isOn: enabled })
        .onChange((isOn: boolean) => {
          // 更新对应选项的状态
          const index = this.preferenceConfig.findIndex(item => item.name === name);
          if (index >= 0) {
            this.preferenceConfig[index].enabled = isOn;
          }
        })
        .selectedColor(Color.Blue)
    }
    .width('100%')
    .height(60)
    .padding({ left: 10, right: 10 })
    .borderRadius(8)
    .margin({ bottom: 10 });
  }

  /**
   * 切换主题
   * @param theme 新的主题键
   */
  private changeTheme(theme: ThemeKey) {
    this.currentTheme = theme; // 更新当前主题
    this.currentConfig = themeConfig[theme]; // 更新当前主题配置
  }
}