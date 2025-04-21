

// 调用方法
// @State Theme:theme = theme.getInstance()
// this.Theme.textColor[this.Theme.modeList[this.Theme.mode]]
@Observed
export class theme{
  // 属性池 (如果想组件颜色这里没有可以自定义,0表示白天,1表示黑夜)
  modeList:number[] = [0,1]   // 模式列表 ()
  mode:number = 0       // 当前模式(后期可以添加时间监听)
  mask: ResourceColor[]|string[] = ["#E9F4F9","#000"]; // 蒙版颜色
  ComponentBGColor:ResourceColor[]|string[] = ["#FFFFFF","#2B323A"];  // 组件颜色(组件与页面得颜色在相同模式下,也有差异)
  textColor: ResourceColor[]|string[] = ["#000","#FFF"]; // 文字颜色
  iconColor: ResourceColor[]|string[] = []; // 图标颜色
  buttonIcon: ResourceColor[]|string[] = []; // 按钮图标资源

  private static instance:theme;
  private constructor() {}


  // 主题对象获取
  public static getInstance(): theme {
    if (!theme.instance) {
      theme.instance = new theme();
    }
    return theme.instance;
  }

}