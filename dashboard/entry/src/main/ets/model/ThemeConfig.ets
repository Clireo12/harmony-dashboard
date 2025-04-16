// 主题配置接口，定义了每个主题的配置项
export interface ThemeConfig {
  bg: Resource; // 背景图片资源
  mask: ResourceColor; // 蒙版颜色
  textColor: ResourceColor; // 文字颜色
  iconColor: ResourceColor; // 图标颜色
  buttonIcon: Resource; // 按钮图标资源
}