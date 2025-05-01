import { Header } from '../../component/Header';
import { Bottom } from '../../component/Bottom';
import { City } from '../../component/City';
import { themeConfig, ThemeConfig,ThemeKey} from '../../model/ThemeConfig'
import { ThemeManager } from '../../model/ThemeManager';
import PreferencesUtil from '../../utils/PreferencesUtil';
import { common } from '@kit.AbilityKit';

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
  @State brightnessValue: number = 0.5;

  @State activeIndex: number = -1; // 表示当前被激活的按钮索引，-1 表示无激活

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
    this.brightnessValue = PreferencesUtil.get('brightnessValue', 0.5) as number;

    // 加载偏好设置
    const savedPreferencesRaw = PreferencesUtil.get('preferenceConfig', '');
    let savedPreferences: PreferenceItem[] = [];

    if (savedPreferencesRaw && typeof savedPreferencesRaw === 'string') {
      try {
        const parsedData: PreferenceItem[] = JSON.parse(savedPreferencesRaw) as PreferenceItem[];
        if (Array.isArray(parsedData) && parsedData.every(item =>
        typeof item.name === 'string' &&
          typeof item.enabled === 'boolean'
        )) {
          savedPreferences = parsedData;
        } else {
          console.warn("Invalid format, using defaults.");
        }
      } catch (error) {
        console.error("Parse failed:", error);
      }
    }

    if (savedPreferences.length > 0) {
      this.preferenceConfig = savedPreferences;
    }

    // 初始化 activeIndex：只保留第一个启用的项作为激活状态
    const active = this.preferenceConfig.findIndex(item => item.enabled);
    this.activeIndex = active >= 0 ? active : -1;
  }

  // 默认偏好设置配置
  private preferenceConfig: PreferenceItem[] = [
    { name: '转向灯提示音', enabled: false },
    { name: '驾驶模式切换音效', enabled: false },
    { name: '故障报警语音播报', enabled: false },
    { name: '仪表盘动画速度', enabled: false },
    { name: '方言识别模式', enabled: false },
    { name: '盲区监测提示', enabled: false },
    { name: '语音反馈模式', enabled: false },
  ];

  private updatePreference(index: number, newState: boolean) {
    this.preferenceConfig[index].enabled = newState;
    PreferencesUtil.put('preferenceConfig', JSON.stringify(this.preferenceConfig));
  }

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
                this.buildBrightnessIcon('left');
                this.buildBrightnessSlider();
                this.buildBrightnessIcon('right');
              }
              .justifyContent(FlexAlign.SpaceEvenly)
              .width('90%')

              //滑块刻度
              Row() {
                ForEach([0, 20, 40, 60, 80, 100], (value: number) => {
                  Text(value.toString())
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
            // Column(){
            //   Text('偏好设置')
            //     .margin({ top: 5})
            //     .width('100%')
            //     .fontSize(this.fontSize)
            //     .fontColor(this.currentTheme.textColor)
            //     .textAlign(TextAlign.Center);
            //
            //   // 动态渲染所有偏好设置项
            //
            //   Column(){
            //     ForEach(this.preferenceConfig, (item: PreferenceItem, index) => {
            //       Row(){
            //         Text(item.name)
            //           .fontSize(this.fontSize-5)
            //           .fontColor(this.currentTheme.textColor)
            //           .layoutWeight(1)
            //           .margin({left : 10});
            //
            //         // 按钮设置
            //         Toggle({ type: ToggleType.Switch, isOn: item.enabled })
            //           .margin({ right: 10 })
            //           .width("20%")
            //           .height("50%")
            //           .onChange((isOn: boolean) => {
            //             this.preferenceConfig[index].enabled = isOn;
            //           })
            //       }
            //       .width('100%')
            //       .height("15%")
            //       .margin({ bottom: 3 });
            //     })
            //   }
            //   .width('100%')
            //   .height("80%")
            //   .margin({ top: 5, bottom: 5 })
            //
            // }
            // .width('45%')
            // .backgroundColor(this.currentTheme.mask)
            // .borderRadius(10)
            // .height("100%")
            // .margin({ left: -110, right: -30 });
            Column() {
              Text('偏好设置')
                .fontSize(this.fontSize)
                .fontColor(this.currentTheme.textColor)
                .textAlign(TextAlign.Center)
                .margin({ top: 5 })

              Column() {
                ForEach(this.preferenceConfig, (item: PreferenceItem, index: number) => {
                  this.buildPreferenceItemWithAnimation(item.name, index)
                })
              }
              .width('100%')
              .height("100%")
              .margin({ top: 5, bottom: 5 })

            }
            .width('50%')
            .backgroundColor(this.currentTheme.mask)
            .borderRadius(10)
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
        .onClick(async () => {
          await this.themeManager.changeTheme(theme);
          this.currentThemeKey = theme;
          this.currentTheme = this.themeManager.getCurrentTheme();
        });

      Text(label)
        .fontSize(this.fontSize-6)
        .fontColor(this.currentTheme.textColor)
        .margin({ top: 10 });
    }
  }

  //构建偏好设置
  @Builder
  buildPreferenceItemWithAnimation(name: string, index: number) {
    Row() {
      // 偏好项文字部分
      Text(name)
        .fontSize(this.fontSize - 6)
        .fontColor(this.themeManager.getCurrentTheme().textColor)
        .layoutWeight(1)
        .textAlign(TextAlign.Start)

      // 自定义开关按钮区域
      Row() {
        Row() {
          Text((this.activeIndex === index) ? "开启" : "关闭")
            .fontSize(18)
            .fontColor(this.themeManager.getCurrentTheme().textColor)
            .textAlign(TextAlign.Center)
        }
        .width("60%")
        .height("100%")
        .margin({
          left: (this.activeIndex === index) ? "40%" : "0%"
        })
        .backgroundColor("#FF7500")
        .borderRadius(25)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          const newState = this.activeIndex !== index;

          this.getUIContext()?.keyframeAnimateTo({ iterations: 1 }, [
            {
              duration: 400,
              event: () => {
                // 使用 updatePreference 方法统一处理状态更新和持久化
                this.updatePreference(index, newState);
                // 更新激活状态
                this.activeIndex = newState ? index : -1;
              }
            }
          ]);
        })
        .shadow({ radius: 10, color: Color.Gray })

      }
      .width(100)
      .height(30)
      .borderRadius(25)
      .backgroundColor("#0E62A9")
      .justifyContent(FlexAlign.Start)
    }
    .width("100%")
    .height(40)
    .justifyContent(FlexAlign.Start)
    .padding({ left: 10, right: 10 })
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
        const context = getContext(this) as common.UIAbilityContext;
        context.eventHub.emit('brightnessChange', {
          brightness: this.brightnessValue
        });
      });
  }

}