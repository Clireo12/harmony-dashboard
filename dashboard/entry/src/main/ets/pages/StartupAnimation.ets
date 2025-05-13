import router from '@ohos.router';
import display from '@ohos.display';

@Entry
@Component
export struct StartupAnimation {
  //获取屏幕尺寸，计算初始位置
  private screenWidth: number = display.getDefaultDisplaySync().width;
  private screenHeight: number = display.getDefaultDisplaySync().height;

  // 动画状态控制
  @State carOffsetX: number = this.screenWidth + 650;//车辆X轴偏移量
  @State textOpacity: number = 0;//文字透明度
  @State textScale: number = 0.8;//文字缩放比例
  @State loadingOpacity: number = 0; //"启动中..."透明度
  @State loadingProgress: number = 0; // 进度条进度

  build() {
    Stack({ alignContent: Alignment.Center}) {

      Column() {
        Image($r('app.media.car'))
          .width(580)
          .height(380)
          .translate({ x: this.carOffsetX, y: 0 }) //图片位移

        Text("鸿蒙智能座舱")
          .fontSize(42)
          .fontColor(Color.White)
          .opacity(this.textOpacity) //透明度
          .scale({ x: this.textScale, y: this.textScale }) //缩放
          .fontWeight(FontWeight.Bold)
          .letterSpacing(5)    //字间距
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ bottom: 10 })

        //启动中文字+进度条
        Column() {
          Text("启动中...")
            .fontSize(24)
            .fontColor('#AAAAAA')
            .opacity(this.loadingOpacity)
            .margin({ bottom: 10 })

          // 进度条
          Stack() {
            //背景条
            Row()
              .width(200)
              .height(4)
              .backgroundColor('#333333')
              .borderRadius(2)

            //进度条
            Row()
              .width(this.loadingProgress * 200)
              .height(4)
              .backgroundColor('#FFFFFF')
              .borderRadius(2)
          }
          .width(200)
          .height(4)
          .margin({ bottom: 10 })
        }
        .opacity(this.loadingOpacity)
      }
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
    .onAppear(() => {
      this.startAnimation();
    })
  }

  private startAnimation() {
    //车辆入场动画
    animateTo({
      duration: 1500,
    }, () => {
      this.carOffsetX = 0;
    });

    //标题显示
    setTimeout(() => {
      animateTo({
        duration: 2000,
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

    //跳转到主页面
      setTimeout(() => {
        router.replace({
          url: 'pages/MainPage',
       });
    }, 3000);
  }
}