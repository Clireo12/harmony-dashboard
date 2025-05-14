import router from '@ohos.router';
import display from '@ohos.display';
import { ThemeManager } from '../model/ThemeManager';
import { ThemeConfig } from '../model/ThemeConfig';

@Entry
@Component
export struct StartupAnimation {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()

  //获取屏幕尺寸，计算初始位置
  @State screenWidth: number = display.getDefaultDisplaySync().width;

  // 动画状态控制
  @State carOffsetX: number = this.screenWidth + 650;//车辆X轴偏移量
  @State textOpacity: number = 0;//文字透明度
  @State textScale: number = 0.8;//文字缩放比例
  @State loadingOpacity: number = 0; //"启动中..."透明度
  @State loadingProgress: number = 0; //进度条进度
  @State bgOpacity: number = 1; //背景透明度
  @State contentOpacity: number = 1;

  build() {
    Stack({ alignContent: Alignment.Center}) {

      //背景（逐渐透明）
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.currentTheme.theme)
        .opacity(this.bgOpacity)

      Column() {
        Image($r('app.media.car'))
          .width(500)
          .height(280)
          .translate({ x: this.carOffsetX, y: 0 })

        Text("鸿蒙智能座舱")
          .fontSize(45)
          .fontColor(this.currentTheme.textColor)
          .opacity(this.textOpacity)
          .scale({ x: this.textScale, y: this.textScale })
          .fontWeight(FontWeight.Bold)
          .letterSpacing(5)
          .textAlign(TextAlign.Center)
          .width('100%')

        Column({ space: 10 }) {
          Text("启动中...")
            .fontSize(24)
            .fontColor('#AAAAAA')
            .opacity(this.loadingOpacity)

          Stack({ alignContent: Alignment.Start }) {
            Row()
              .width(200)
              .height(4)
              .backgroundColor(this.currentTheme.theme)
              .borderRadius(2)

            Row()
              .width(this.loadingProgress * 200)
              .height(4)
              .backgroundColor(this.currentTheme.textColor)
              .borderRadius(2)
          }
          .width(200)
          .height(4)
        }
        .opacity(this.loadingOpacity)
      }
      .opacity(this.contentOpacity)
    }
    .width('100%')
    .height('100%')
    .onAppear(() => {
      this.startAnimation();
    })
  }

  private startAnimation() {
    //车辆入场动画
    animateTo({
      duration: 1500,
      curve: Curve.EaseOut
    }, () => {
      this.carOffsetX = 0;
    });

    //标题显示
    setTimeout(() => {
      animateTo({
        duration: 1500,
        curve: Curve.EaseOut
      }, () => {
        this.textOpacity = 1;  //文字完全显示
        this.textScale = 1.0;  //文字恢复到原始大小
      });
    }, 700);

    //显示加载状态
    setTimeout(() => {
      animateTo({
        duration: 500,
        curve: Curve.EaseOut
      }, () => {
        this.loadingOpacity = 1;
      });

      //进度条动画
      animateTo({
        duration: 1500,
        curve: Curve.Linear
      }, () => {
        this.loadingProgress = 1;
      });
    }, 1500);

    setTimeout(() => {
      animateTo({ duration: 500 }, () => {
        this.textOpacity = 0;
        this.loadingOpacity = 0;
        this.bgOpacity = 0;
        this.contentOpacity = 0;
      });

    //跳转到主页面
      setTimeout(() => {
        router.replace({
          url: 'pages/MainPage',
       });
      }, 500);
    }, 3000);
  }
}