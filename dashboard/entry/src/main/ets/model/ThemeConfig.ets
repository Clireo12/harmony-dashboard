
// 主题配置接口，定义了每个主题的配置项
export interface ThemeConfig {
  theme: ResourceColor;
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
    theme: $r('app.color.theme_green'),
    mask: $r('app.color.mask_green'),
    textColor: $r('app.color.text_color_light'),
    iconColor: $r('app.color.text_color_dark'),
    buttonIcon: $r("app.media.fresh_green")
  },
  'tech-blue': {
    theme: $r('app.color.theme_blue'),
    mask: $r('app.color.mask_blue'),
    textColor: $r('app.color.text_color_light'),
    iconColor: $r('app.color.text_color_light'),
    buttonIcon: $r('app.media.bg_tech_blue')
  },
  'minimal-white': {
    theme: $r('app.color.theme_white'),
    mask: $r('app.color.mask_white'),
    textColor: $r('app.color.text_color_light'),
    iconColor: $r('app.color.text_color_light'),
    buttonIcon: $r('app.media.bg_minimal_white')
  },
  'classic-blackRed': {
    theme: $r('app.color.theme_black'),
    mask: $r('app.color.mask_black'),
    textColor: $r('app.color.text_color_dark'),
    iconColor: $r('app.color.text_color_dark'),
    buttonIcon: $r('app.media.bg_classic_blackRed')
  }
};
