import { ThemeConfig, themeConfig,ThemeKey } from '../model/ThemeConfig';
import PreferencesUtil from '../utils/PreferencesUtil';

@Observed
export class ThemeManager {
  // 当前主题键
  private currentThemeKey: ThemeKey = 'minimal-white';
  // 时间主题（白天/黑夜）
  private timeBasedTheme: ThemeKey = 'minimal-white';
  // 用户选择的主题（undefined表示使用时间主题）
  private userSelectedTheme: ThemeKey | undefined = undefined;
  // 时间检查定时器
  private timeCheckTimer: number | null = null;

  private static instance: ThemeManager;

  private listeners: Array<() => void> = [];

  // 添加监听器方法
  public addThemeChangeListener(listener: () => void): void {
    this.listeners.push(listener);
  }

  // 移除监听器方法
  public removeThemeChangeListener(listener: () => void): void {
    this.listeners = this.listeners.filter(l => l !== listener);
  }

  private constructor() {
    this.checkTimeAndUpdateTheme();
    // 从持久化存储中加载用户选择的主题
    this.loadUserSelectedTheme().then(() => {
      this.checkTimeAndUpdateTheme();
      this.startTimeChecker();
    });
  }

  // 获取单例实例
  public static getInstance(): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager();
    }
    return ThemeManager.instance;
  }

  // 从持久化存储中加载用户选择的主题
  private async loadUserSelectedTheme(): Promise<void> {
    const savedTheme = await PreferencesUtil.get('userSelectedTheme', '');
    if (savedTheme && Object.keys(themeConfig).includes(savedTheme as string)) {
      this.userSelectedTheme = savedTheme as ThemeKey;
      this.currentThemeKey = this.userSelectedTheme
    }
  }

  // 启动时间检查器
  private startTimeChecker() {
    this.timeCheckTimer = setInterval(() => {
      this.checkTimeAndUpdateTheme();
    }, 60000); // 每分钟检查一次
  }

  // 检查当前时间并更新主题
  private checkTimeAndUpdateTheme(): void {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; // 6:00-18:00为白天
    this.timeBasedTheme = isDayTime ? 'classic-blackRed' : 'minimal-white';

    if (this.userSelectedTheme === undefined) {
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
  public async changeTheme(themeKey: ThemeKey): Promise<void> {
    await PreferencesUtil.put('userSelectedTheme', themeKey);
    this.userSelectedTheme = themeKey;
    this.currentThemeKey = themeKey;
    this.notifyListeners();
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => listener());
  }

  // 重置为时间主题
  public async resetToTimeBasedTheme(): Promise<void> {
    this.userSelectedTheme = undefined;
    this.currentThemeKey = this.timeBasedTheme;
  }

  // 清理资源
  public cleanup(): void {
    if (this.timeCheckTimer) {
      clearInterval(this.timeCheckTimer);
      this.timeCheckTimer = null;
    }
  }
}