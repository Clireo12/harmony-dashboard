import { Header } from '../../component/Header';
import { Bottom } from '../../component/Bottom';
import { City } from '../../component/City';
import { themeConfig, ThemeConfig } from '../../model/ThemeConfig'
import { ThemeManager } from '../../model/ThemeManager';
import PreferencesUtil from '../../utils/PreferencesUtil';

// 定义主题键类型，用于标识不同的主题
type ThemeKey = 'fresh-green' | 'tech-blue' | 'minimal-white' | 'classic-blackRed';

// 定义偏好设置项的类型
interface PreferenceItem {
  name: string;       // 选项名称（如“相机灯显示屏”）
  enabled: boolean;    // 是否启用
}

@Entry
@Component
export struct PersonalizationSettings {
  @StorageProp('fontSize') fontSize: number = 20;
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentThemeKey: ThemeKey = this.themeManager.getCurrentThemeKey();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  @State brightnessValue: number = 0; // 亮度值

  // 提供默认的BuilderParam
  @BuilderParam content: () => void = this.defaultContent;

  // 默认内容构建器
  @Builder
  defaultContent() {
    Column() {
      // 可以留空或添加默认占位内容
    }
  }

  aboutToAppear(): void {

    // 初始化亮度值
    this.brightnessValue = PreferencesUtil.get('brightnessValue',0) as number

    // 加载偏好设置
    const savedPreferencesRaw = PreferencesUtil.get('preferenceConfig', ''); // 默认值为空字符串 调用 PreferencesUtil.get 方法，尝试获取 preferenceConfig 对应的值。如果该键不存在，则返回默认值空字符串 ''。
    let savedPreferences: PreferenceItem[] = []; //初始化一个空的 savedPreferences 数组，用于存储解析后的偏好设置数据。

    if (savedPreferencesRaw && typeof savedPreferencesRaw === 'string') { //确保 savedPreferencesRaw 不为空且是字符串。
      try {
        // 使用类型断言明确 JSON 解析结果的类型
        const parsedData: PreferenceItem[] = JSON.parse(savedPreferencesRaw) as PreferenceItem[]; //将 savedPreferencesRaw 解析为 PreferenceItem[] 类型的数组。

        // 验证解析结果是否符合预期格式 验证解析后的数据是否为有效的 PreferenceItem[] 数组。
        if (Array.isArray(parsedData) && parsedData.every(item =>
        typeof item === 'object' &&
          item !== null && // 确保不是 null
          typeof item.name === 'string' && // 直接检查 name 是否为字符串
          typeof item.enabled === 'boolean' // 直接检查 enabled 是否为布尔值
        )) {
          savedPreferences = parsedData; //如果验证通过，将解析后的数据赋值给 savedPreferences。
        } else {
          console.warn("PreferenceConfig format is invalid, using default preferences.");
        }
      } catch (error) {
        console.error("Failed to parse preferenceConfig:", error);
      }
    }

    if (savedPreferences.length > 0) {
      this.preferenceConfig = savedPreferences; //如果 savedPreferences 数组中有数据，则将其赋值给 this.preferenceConfig。
    }

  }

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



  build() {
    Column(){
      this.content
      // 添加 Header 组件
      Header({ currentTheme: this.currentTheme })

      Stack() {

        // 控制面板，包含主题切换和亮度调节区域
        Row() {
          // 左侧：主题切换和亮度调节区域
          Column() {
            // 主题切换区域
            Column() {
              // 主题切换标题
              Text('主题切换')
                .fontSize(this.fontSize)
                .fontColor(this.currentTheme.textColor)
                .textAlign(TextAlign.Center)
                .margin({ top: 10, bottom: 10 });

              // 主题切换按钮
              Row() {
                this.buildThemeButton('classic-blackRed', '经典红黑'); // 经典红黑主题按钮
                this.buildThemeButton('tech-blue', '科技蓝'); // 科技蓝主题按钮
                this.buildThemeButton('minimal-white', '极简白'); // 极简白主题按钮
                this.buildThemeButton('fresh-green', '清新绿'); // 清新绿主题按钮
              }
              .justifyContent(FlexAlign.SpaceEvenly)
              .width('100%')
              .padding({ bottom: 10 });
            }
            .padding({ top: 10 })
            .width('80%')
            .height('60%')
            .backgroundColor(this.currentTheme.mask)
            .borderRadius(10)
            .margin({ left : -100,bottom: 20 });

            // 亮度调节区域
            Column() {
              Text('亮度调节')
                .fontSize(this.fontSize)
                .fontColor(this.currentTheme.textColor)
                .textAlign(TextAlign.Center)
                .margin({ top: 5, bottom: 5 });

              //滑块和图标
              Row() {
                this.buildBrightnessIcon('left'); // 左侧亮度图标
                this.buildBrightnessSlider(); // 亮度滑块
                this.buildBrightnessIcon('right'); // 右侧亮度图标
              }
              .justifyContent(FlexAlign.SpaceEvenly)
              .width('90%')

              //滑块刻度
              Row() {
                ForEach([0, 20, 40, 60, 80, 100], (value: number) => {
                  Text(value.toString()) // 亮度刻度数字
                    .fontColor(this.currentTheme.textColor)
                    .width('10%')
                    .textAlign(
                      value === 0 ? TextAlign.Start :
                        value === 100 ? TextAlign.End :
                        TextAlign.Center
                    );
                })
              }
              .justifyContent(FlexAlign.SpaceEvenly)
              .width('87%');
            }
            .width('80%')
            .height('35%')
            .padding({ bottom: 15 })
            .justifyContent(FlexAlign.SpaceEvenly)
            .backgroundColor(this.currentTheme.mask)
            .margin({left : -100})
            .borderRadius(10);
          }
          .width('50%')
          .padding({ left: 30 })
          .height("85%")

          // 右侧
          Row() {
            //偏好设置
            Column(){
              Text('偏好设置')
                .margin({ top: 5})
                .width('100%')
                .fontSize(this.fontSize)
                .fontColor(this.currentTheme.textColor)
                .textAlign(TextAlign.Center);

              // 动态渲染所有偏好设置项

              Column(){
                ForEach(this.preferenceConfig, (item: PreferenceItem, index) => {
                  Row(){
                    Text(item.name)
                      .fontSize(this.fontSize-5)
                      .fontColor(this.currentTheme.textColor)
                      .layoutWeight(1)
                      .margin({left : 10});

                    // 按钮设置
                    Toggle({ type: ToggleType.Switch, isOn: item.enabled })
                      .margin({ right: 10 })
                      .width("20%")
                      .height("50%")
                      .onChange((isOn: boolean) => {
                        this.preferenceConfig[index].enabled = isOn;
                      })
                  }
                  .width('100%')
                  .height("15%")
                  .margin({ bottom: 3 });
                })
              }
              .width('100%')
              .height("80%")
              .margin({ top: 5, bottom: 5 })

            }
            .width('45%')
            .backgroundColor(this.currentTheme.mask) // 背景颜色随主题切换
            .borderRadius(10)
            .height("100%")
            .margin({ left: -110, right: -30 });

            //汽车图片
            Stack(){
              City()
              Image($r('app.media.car')).width(480).height(300)
            }
          }
          .width('50%')
          .height("85%")
          .padding({ left: 30 });

        }
        .width('100%')
        .height('100%');
      }
      .layoutWeight(1)

      // 添加 Bottom 组件
      Bottom({ currentTheme: this.currentTheme })

    }
    .onAppear(() => {
      // 确保每次显示时获取最新主题
      this.currentThemeKey = this.themeManager.getCurrentThemeKey();
    })
    .backgroundColor(this.currentTheme.theme)
  }

  // 构建主题切换按钮
  @Builder
  buildThemeButton(theme: ThemeKey, label: string) {
    Column() {
      Image(themeConfig[theme].buttonIcon)
        .width(75)
        .height(75)
        .borderRadius(40)
        .onClick(() => {
          this.themeManager.changeTheme(theme); // 调用 ThemeManager 的 changeTheme 方法
          this.currentThemeKey = theme; // 更新当前主题状态
          this.currentTheme = this.themeManager.getCurrentTheme()
        });

      Text(label)
        .fontSize(this.fontSize-6)
        .fontColor(this.currentTheme.textColor)
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
      .fillColor(this.currentTheme.iconColor);
  }

  /**
   * 构建亮度调节滑块
   */
  @Builder
  buildBrightnessSlider() {
    Slider({
      value: this.brightnessValue * 100,
      min: 0,
      max: 100,
      step: 10,
      style: SliderStyle.InSet
    })
      .trackThickness(20)
      .showSteps(true)
      .showTips(true)
      .width('90%')
      .onChange((value: number) => {
        this.brightnessValue = value / 100; // 更新亮度值
        PreferencesUtil.put('brightnessValue',this.brightnessValue)
      });
  }

  // 构建单个偏好设置项的方法
  @Builder
  buildPreferenceItem(name: string, enabled: boolean) {
    Row() {
      Column() {
        Text(name)
          .fontSize(this.fontSize-6)
          .fontColor(this.currentTheme.textColor)
          .textAlign(TextAlign.Start)

      }
      .layoutWeight(1)

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
    .height("30%")
    .padding({ left: 10, right: 10 })
    .borderRadius(8)

  }

}