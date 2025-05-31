import router from '@ohos.router';
import display from '@ohos.display';

/*
  * 启动动画
  * 1.初始状态：车辆位于屏幕右侧外；标题文字透明度为0（不可见），缩放为0.8倍；加载提示区域不可见，进度条进度为0
  * 2.动画开始：车辆从右侧滑入到屏幕中央（1.5秒），标题文字淡入并放大到正常大小（延迟0.7秒开始，持续1.3秒）
  * 3.  1.5秒后：显示"启动中..."文字和进度条，进度条开始填充（2秒内从0%到100%），启动省略号动画（每0.5秒更新一次）
  * 4.  3.5秒后：显示"点击进入主页"提示，清除省略号动画定时器
  * 5.  用户点击后：跳转到主页面
 */

@Entry
@Component
export struct StartupAnimation {
  //获取屏幕尺寸，计算初始位置
  @State screenWidth: number = display.getDefaultDisplaySync().width;

  //动画状态控制
  @State carOffsetX: number = this.screenWidth + 650;//车辆X轴偏移量（屏幕外右侧）
  @State textOpacity: number = 0;   //文字透明度
  @State textScale: number = 0.8;   //文字缩放比例
  @State loadingOpacity: number = 0;  //加载提示透明度
  @State loadingProgress: number = 0;   //进度条进度（0-1）
  @State contentOpacity: number = 1;  //整体内容透明度
  @State dots: string = ''; //动态省略号（"启动中..."）
  @State showClickPrompt: boolean = false;  //是否显示点击提示

  private dotsTimer: number = 0;  //定时器ID，用于更新省略号
  private dotCount: number = 0;   //省略号数量计数器

  aboutToDisappear() {
    if (this.dotsTimer) {
      clearInterval(this.dotsTimer);  //清除省略号动画定时器
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center}) {

      //背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)

      Column() {

        //车辆图片动画
        Row(){
          Image($r('app.media.car'))
            .width(500)
            .height(280)
            .translate({ x: this.carOffsetX, y: 0 })
            .animation({
              duration: 1500,
              curve: Curve.EaseOut  //缓动曲线：先快后慢
            })
        }

        //标题文本动画
        Row() {
          Text("鸿蒙智能座舱")
            .fontSize(45)
            .fontColor(Color.White)
            .opacity(this.textOpacity)
            .scale({ x: this.textScale, y: this.textScale })
            .fontWeight(FontWeight.Bold)
            .letterSpacing(5)
            .textAlign(TextAlign.Center)
            .width('100%')
            .animation({
              duration: 1300,
              delay: 700,
              curve: Curve.EaseOut
            })
        }
        .margin({ top: -20 })

        //加载提示
        Column({ space: 10 }) {
          //加载中提示（进度条完成前显示）
          if (!this.showClickPrompt) {
            Row() {
              Text("启动中")
                .fontSize(24)
                .fontColor('#AAAAAA')
              Text(this.dots)
                .fontSize(24)
                .fontColor('#AAAAAA')
            }
            .opacity(this.loadingOpacity)

            //进度条动画
            Stack({ alignContent: Alignment.Start }) {
              //背景黑色条
              Row()
                .width(200)
                .height(4)
                .backgroundColor(Color.Black)
                .borderRadius(2)

              //白色进度条
              Row()
                .width(this.loadingProgress * 200)
                .height(4)
                .backgroundColor(Color.White)
                .borderRadius(2)
                .animation({
                  duration: 2000,
                  curve: Curve.Linear //线性动画（匀速）
                })
            }
            .width(200)
            .height(4)
          }

            //点击提示（进度条完成后显示）
            if (this.showClickPrompt) {
              Text("点击进入主页")
                .fontSize(24)
                .fontColor('#AAAAAA')
                .margin({ top: 10 })
                .onClick(() => {
                  router.replace({
                    url: 'pages/MainPage',
                  });
                })
            }
          }
          .margin({ top: 10 })
            .opacity(this.loadingOpacity)
        }
        .opacity(this.contentOpacity)
      }
      .width('100%')
      .height('100%')
      .onClick(() => {
        //如果显示了点击提示，则点击任意位置都可以跳转
        if (this.showClickPrompt) {
          router.replace({
            url: 'pages/MainPage',
          });
        }
      })
      .onAppear(() => {
        //车辆移动到中间
        this.carOffsetX = 0;

        //标题淡入并放大
        this.textOpacity = 1;
        this.textScale = 1.0;

        //1.5秒后显示加载提示，并开始进度条和省略号动画
        setTimeout(() => {
          this.loadingOpacity = 1;
          this.loadingProgress = 1;
          this.dotsTimer = setInterval(() => {
            this.dotCount = (this.dotCount + 1) % 4;
            this.dots = '.'.repeat(this.dotCount);
          }, 500);

          //2秒后进度条完成，显示点击提示
          setTimeout(() => {
            this.showClickPrompt = true;
            if (this.dotsTimer) {
              clearInterval(this.dotsTimer);
            }
          }, 2000);
        }, 1500);
      })
    }
  }