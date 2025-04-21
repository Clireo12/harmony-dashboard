
// 主题配置接口，定义了每个主题的配置项
export interface ThemeConfig {
  mask: ResourceColor; // 蒙版颜色
  textColor: ResourceColor; // 文字颜色
  iconColor: ResourceColor; // 图标颜色
  buttonIcon: Resource; // 按钮图标资源
}

// 定义主题键类型
export type ThemeKey = 'fresh-green' | 'tech-blue' | 'minimal-white' | 'classic-blackRed';
// 主题配置，定义了每个主题的具体配置

export const themeConfig: Record<ThemeKey, ThemeConfig> = {
  'fresh-green': {
    mask: $r('app.color.theme_green'), // 蒙版颜色
    textColor: $r('app.color.theme_black'), // 文字颜色
    iconColor: $r('app.color.theme_black'), // 图标颜色
    buttonIcon: $r('app.media.fresh-green') // 按钮图标
  },
  'tech-blue': {
    mask: $r('app.color.theme_blue'),
    textColor: $r('app.color.theme_white'),
    iconColor: $r('app.color.theme_white'),
    buttonIcon: $r('app.media.bg_tech_blue')
  },
  'minimal-white': {
    mask: $r('app.color.theme_white'),
    textColor: $r('app.color.theme_black'),
    iconColor: $r('app.color.theme_black'),
    buttonIcon: $r('app.media.bg_minimal_white')
  },
  'classic-blackRed': {
    mask: $r('app.color.theme_black'),
    textColor: $r('app.color.theme_white'),
    iconColor: $r('app.color.theme_white'),
    buttonIcon: $r('app.media.bg_classic_blackRed')
  }
};
