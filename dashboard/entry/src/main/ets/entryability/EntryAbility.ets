import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import PreferencesUtil from '../utils/PreferencesUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import IotDataTool from '../utils/IotDataTool'
import { playerManager } from '../pages/MusicPage/PlayerManager';


const DOMAIN = 0x0000;

interface BrightnessEventData {
  brightness: number;
}

export default class EntryAbility extends UIAbility {
  private windowClass: window.Window | undefined = undefined;


  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    PreferencesUtil.Load(this.context);
    IotDataTool.login() // 获取token
    IotDataTool.startPolling()  // 开启轮询
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    IotDataTool.stopPolling() // 停止轮询
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    playerManager.init() // 音乐
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    PreferencesUtil.Load(this.context)
    let names = []
    try {
      //设置全屏和隐藏系统栏
      windowStage.getMainWindowSync().setWindowLayoutFullScreen(true,(err)=>{
        if (err.code) {
          console.error('Failed to enable the full-screen mode. Cause: ' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in enabling the full-screen mode.');
      })
      windowStage.getMainWindowSync().setWindowSystemBarEnable(names, (err) => {
        if (err.code) {
          console.error('Failed to set the system bar to be invisible. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting the system bar to be invisible.');
      });
    } catch (exception) {
      console.error('Failed to set the system bar to be invisible. Cause:' + JSON.stringify(exception));
    }

    windowStage.loadContent('pages/StartupAnimation', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });

    windowStage.getMainWindow((err: BusinessError, data) => {
      if (!err.code && data) {
        this.windowClass = data;
        this.updateWindowBrightness();
      }
    });

    this.context.eventHub.on('brightnessChange', (data: BrightnessEventData) => {
      this.updateBrightness(data.brightness);
    });
  }

  private updateWindowBrightness(): void {
    const brightness = PreferencesUtil.get('brightnessValue', 0.5) as number;
    this.updateBrightness(brightness);
  }

  private updateBrightness(brightness: number): void {
    this.windowClass?.setWindowBrightness(brightness, (err: BusinessError) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Set brightness failed: %{public}d', err.code);
      }
    });
  }

  onWindowStageDestroy(): void {
    playerManager.destroy() // 音乐
    this.context.eventHub.off('brightnessChange');
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    this.updateWindowBrightness();
    IotDataTool.login() // 获取token
    IotDataTool.startPolling()  // 开启轮询

  }

  onBackground(): void {
    // Ability has back to background
    IotDataTool.stopPolling() // 停止轮询
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}