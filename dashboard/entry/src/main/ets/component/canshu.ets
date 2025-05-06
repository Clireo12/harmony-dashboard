export class CommonConstant{
  static readonly IAM_ENDPOINT="4fbeca57d5.st1.iotda-app.cn-south-1.myhuaweicloud.com"
  static readonly ENDPOINT="iam.cn-south-1.myhuaweicloud.com"
  static readonly project_id="5c82a07efebf41aab9c72daa79c7ca07"
  static readonly product_id: string="680e36450ed8b074bf7662e3"
  static readonly device_id: string="680e36450ed8b074bf7662e3_smart_test"
  static readonly DOMAIN_USERNAME="hid_oz-ch57ok3buwvx"
  static readonly IAM_USERNAME="test"
  static readonly IAM_PASSWORD="Chenjinghan2154"
  static readonly AUTH_TOKEN=CommonConstant.IAM_ENDPOINT+"/v3/auth/tokens"
  static token=""
  static readonly INSTANCE_ID="571f6ec7-69f2-441e-a3a7-1a008e82f31d"
  //获取设备影子数据，也就是设备上报的数据
  static readonly SHOW_SHADOW=CommonConstant.ENDPOINT+"/v5/iot/"+CommonConstant.project_id+"/devices/"+CommonConstant.device_id+"/shadow"
  //控制设备-同步下发设备命令
  static readonly CONTROL_DEVICE_SYNC=CommonConstant.ENDPOINT+"/v5/iot/"+CommonConstant.project_id+"/devices/"+CommonConstant.device_id+"/commands"
}