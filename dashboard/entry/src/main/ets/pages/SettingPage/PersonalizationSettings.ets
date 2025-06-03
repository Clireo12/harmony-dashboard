import { Header } from '../../component/Header';
import { City } from '../../component/City';
import { themeConfig, ThemeConfig,ThemeKey} from '../../model/ThemeConfig'
import { ThemeManager } from '../../model/ThemeManager';
import PreferencesUtil from '../../utils/PreferencesUtil';
import { common } from '@kit.AbilityKit';
import { PreferenceModel } from './PreferenceModel';
import { router } from '@kit.ArkUI';

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


  aboutToAppear(): void {
    // 初始化亮度值
    this.brightnessValue = PreferencesUtil.get('brightnessValue', 0.5) as number;
  }

  // 默认偏好设置配置
  @State private preferenceConfig: PreferenceItem[] = [
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

      //添加 Header 组件
      Header({ currentTheme: this.currentTheme })

      Row() {
        Image($r("app.media.back"))
          .width(40)
          .fillColor(this.currentTheme.iconColor)
          .onClick(() => {
            router.back({
              url: 'pages/MainPage'
            })
          })
          .margin({ left: 32 })
      }
      .width('100%')
      .height(30)
      .justifyContent(FlexAlign.Start)

      Stack() {

        Row() {
          //左侧：主题切换和亮度调节区域
          Column() {

            Column() {

              Text('主题切换')
                .fontSize(this.fontSize+2)
                .fontColor(this.currentTheme.textColor)
                .textAlign(TextAlign.Center)
                .margin({ top: 10, bottom: 10 });

              //主题切换按钮
              Row() {
                this.buildThemeButton('classic-blackRed', '经典暗黑'); // 经典暗黑主题按钮
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
            .borderRadius(25)
            .margin({ left : -100,bottom: 20 });

            //亮度调节区域
            Column() {
              Text('亮度调节')
                .fontSize(this.fontSize+2)
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
            .borderRadius(25)
          }
          .width('50%')
          .padding({ left: 30 })
          .height("85%")

          // 右侧
          Row() {
            // 偏好设置
            Column(){
              PreferenceModel()
            }
            .width('56%')
            .backgroundColor(this.currentTheme.mask)
            .borderRadius(25)
            .height("100%")
            .margin({ left: -110, right: -45 });

            //汽车图片
            Stack(){
              City()
              Image($r('app.media.car')).width(450).height(300)
            }
          }
          .width('50%')
          .height("85%")
          .padding({ left: 30 });
        }
        .width('100%')
        .height('100%')
      }
      .layoutWeight(1)


      // //添加 Bottom
      // Bottom({ currentTheme: this.currentTheme })

    }
    .backgroundColor(this.currentTheme.theme)
  }

  //主题切换按钮
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

  // 构建单个偏好设置项的方法
  @Builder
  buildPreferenceItem(name: string, enabled: boolean) {
    Row() {
      Column() {
        Text(name) // 选项名称
          .fontSize(this.fontSize-6)
          .fontColor(this.currentTheme.textColor)
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


  //亮度图标
  @Builder
  buildBrightnessIcon(position: 'left' | 'right') {
    Image(position === 'left' ? $r('app.media.sun_left') : $r('app.media.sun_right')) // 亮度图标
      .width(24)
      .height(24)
      .fillColor(this.currentTheme.iconColor);
  }

  //构建亮度调节滑块
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