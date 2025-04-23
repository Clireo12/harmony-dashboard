// theme.ts
import { ThemeConfig, themeConfig } from '../model/ThemeConfig';

// 主题键类型
export type ThemeKey = 'fresh-green' | 'tech-blue' | 'minimal-white' | 'classic-blackRed';

@Observed
export class ThemeManager {
  // 当前主题键
  currentThemeKey: ThemeKey = 'minimal-white';

  // 时间主题（白天/黑夜）
  private timeBasedTheme: ThemeKey = 'minimal-white';

  // 用户选择的主题（null表示使用时间主题）
  private userSelectedTheme: ThemeKey | null = null;

  // 时间检查定时器
  private timeCheckTimer: number | null = null;

  private static instance: ThemeManager;

  private constructor() {
    this.checkTimeAndUpdateTheme();
    this.startTimeChecker();
  }

  // 获取单例实例
  public static getInstance(): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager();
    }
    return ThemeManager.instance;
  }

  // 启动时间检查器
  private startTimeChecker() {
    this.timeCheckTimer = setInterval(() => {
      this.checkTimeAndUpdateTheme();
    }, 60000); // 每分钟检查一次
  }

  // 检查当前时间并更新主题
  private checkTimeAndUpdateTheme() {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; // 6:00-18:00为白天

    this.timeBasedTheme = isDayTime ?   'classic-blackRed':'minimal-white';

    // 只有用户没有选择主题时才更新时间主题
    if (this.userSelectedTheme === null) {
      this.currentThemeKey = this.timeBasedTheme;
    }
  }

  // 获取当前主题配置
  public getCurrentTheme(): ThemeConfig {
    return themeConfig[this.currentThemeKey];
  }

  // 获取当前主题键
  public getCurrentThemeKey(): ThemeKey {
    return this.currentThemeKey;
  }

  // 更改主题（用户选择）
  public changeTheme(themeKey: ThemeKey) {
    this.userSelectedTheme = themeKey;
    this.currentThemeKey = themeKey;
  }

  // 重置为时间主题
  public resetToTimeBasedTheme() {
    this.userSelectedTheme = null;
    this.currentThemeKey = this.timeBasedTheme;
  }

  // 清理资源
  public cleanup() {
    if (this.timeCheckTimer) {
      clearInterval(this.timeCheckTimer);
    }
  }
}