import { common } from '@kit.AbilityKit'
import stack from '../../utils/route'

@Extend(Row)
function PhoneLoginRowStyle() {
  .padding({ left: 20, right: 15 })
  .height(50)
  .width('100%')
  .backgroundColor('#fff')
  .borderRadius(25)
}

@Extend(TextInput)
function textInputStyle() {
  .type(InputType.Number)
  .borderRadius(0)
  .caretColor('#cecece')
  .placeholderColor('#cecece')
  .backgroundColor(Color.Transparent)
  .padding(0)
  .layoutWeight(1)
}

@Builder
export function LoginBuilder() {
  Login()
}

@ComponentV2
struct Login {
  //0 默认登录 1 手机号登录 2 账号密码登录 3 未同意协议手机号登录 4 未同意协议账号密码登录 5 手机登录页面未同意协议
  @Local loginType: number = 0
  @Local isAgree: boolean = true
  @Local phoneCode: string = '86'
  @Local loginTypeList: ResourceStr[] = [
    $r('app.media.login_wechat'),
    $r('app.media.login_QQ'),
    $r('app.media.login_douyin'),
    $r('app.media.more')
  ]
  @Local offsetY: number = 0
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  agreementDialogController: CustomDialogController = new CustomDialogController({
    builder: this.agreementDialogBuilder,
    width: 300,
    cornerRadius: 15,
    autoCancel: false,
    backgroundColor: '#fff'
  })

  @Builder
  agreementDialogBuilder() {
    Column({ space: 15 }) {
      Text('用户服务协议和隐私协议')
        .width('100%')
        .fontSize(18)
        .fontColor('#1c1c1c')
        .fontWeight(600)
        .textAlign(TextAlign.Center)
      Text() {
        Span('我已阅读并同意')
        Span('《用户服务协议》')
          .fontColor('#6773c7')
        Span('及')
        Span('《隐私协议》')
          .fontColor('#6773c7')
        Span('，未注册手机登录后将自动创建起点账号')
      }
      .lineHeight(20)
      .width('100%')
      .fontSize(14)
      .fontColor('#777')

      Row() {
        Button('不同意')
          .fontWeight(500)
          .width(115)
          .height(45)
          .backgroundColor('#ffe7e7')
          .fontColor('#e43640')
          .onClick(() => {
            this.agreementDialogController.close()
          })
        Button('同意并继续')
          .fontWeight(500)
          .width(115)
          .height(45)
          .backgroundColor('#e43640')
          .fontColor('#fff')
          .onClick(() => {
            this.isAgree = true
            this.agreementDialogController.close()
            if (this.loginType == 3) {
              this.loginType = 1
            } else if ([4, 5].includes(this.loginType)) {
              this.loginType = 0
              stack.pushPathByName('AccountLogin', null)
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding({
      top: 30,
      bottom: 25,
      left: 25,
      right: 25
    })
  }

  @Builder
  loginOption(text: string, icon: ResourceStr) {
    Row({ space: 5 }) {
      Image(icon)
        .width(24)
      Text(text)
        .fontWeight(500)
        .fontColor('#030303')
    }
    .justifyContent(FlexAlign.Center)
    .height(50)
    .width('100%')
    .backgroundColor('#fff')
    .borderRadius(30)
  }

  build() {
    NavDestination() {
      Stack() {
        Image($r('app.media.login_bg'))
          .objectFit(ImageFit.Fill)
          .expandSafeArea([SafeAreaType.SYSTEM])
        Column() {
          Row() {
            Image($r('app.media.close'))
              .fillColor('#fff')
              .width(30)
              .onClick(() => {
                this.context.terminateSelf()
              })
          }
          .padding(15)
          .width('100%')

          Column({ space: 30 }) {
            if ([0, 3, 4].includes(this.loginType)) {
              Column({ space: 20 }) {
                this.loginOption('微信登录', $r('app.media.wechat'))
                this.loginOption('QQ登录', $r('app.media.QQ'))
                this.loginOption('抖音登录', $r("app.media.Douyin"))
                Row() {
                  Row() {
                    Image($r('app.media.phone'))
                      .width(24)
                  }
                  .justifyContent(FlexAlign.Center)
                  .border({ radius: '50%', width: 1, color: '#fff' })
                  .width(50)
                  .height(50)
                  .onClick(() => {
                    if (!this.isAgree) {
                      this.loginType = 3
                      this.agreementDialogController.open()
                    } else {
                      this.loginType = 1
                    }
                  })

                  Row() {
                    Image($r('app.media.more'))
                      .width(24)
                  }
                  .justifyContent(FlexAlign.Center)
                  .border({ radius: '50%', width: 1, color: '#fff' })
                  .width(50)
                  .height(50)
                  .onClick(() => {
                    if (!this.isAgree) {
                      this.loginType = 4
                      this.agreementDialogController.open()
                    } else {
                      stack.pushPathByName('AccountLogin', null)
                    }
                  })
                }
                .margin({ top: 10 })
                .width('100%')
                .justifyContent(FlexAlign.SpaceAround)
              }
            } else {
              Column({ space: 12 }) {
                Row({ space: 10 }) {
                  Image($r('app.media.login_phone'))
                    .width(24)
                  Text(`+${this.phoneCode}`)
                    .fontColor('#1b1b1b')
                    .fontWeight(500)
                    .margin({ left: 5, right: 5 })
                    .onClick(() => {
                      stack.pushPathByName('CountryList', '', (data) => {
                        this.phoneCode = data.result['code']
                      })
                    })

                  Image($r('app.media.login_phone_more'))
                    .width(12)
                  TextInput({ placeholder: '请输入手机号' })
                    .textInputStyle()
                    .onFocus(() => {
                      this.offsetY = -260
                    })
                    .onBlur(() => {
                      this.offsetY = 0
                    })
                }
                .PhoneLoginRowStyle()

                Row({ space: 10 }) {
                  Image($r('app.media.login_code'))
                    .width(24)
                  TextInput({ placeholder: '请输入短信验证码' })
                    .textInputStyle()
                    .onFocus(() => {
                      this.offsetY = -260
                    })
                    .onBlur(() => {
                      this.offsetY = 0
                    })
                  Divider().strokeWidth(1).color('#cecece').height(25).vertical(true)
                  Text('获取验证码')
                    .fontColor('#921721')
                }
                .PhoneLoginRowStyle()

                Row() {
                  Text('登录')
                    .fontColor('#a94950')
                    .fontSize(18)
                    .fontWeight(600)
                    .width('100%')
                    .textAlign(TextAlign.Center)
                }
                .PhoneLoginRowStyle()
                .backgroundColor('#921721')

                Text('密码登录')
                  .fontSize(13)
                  .fontColor('rgba(255,255,255,0.75)')
                  .margin({ top: 6, bottom: 6 })
                  .onClick(() => {
                    stack.pushPathByName('AccountLogin', null)
                  })
                Row() {
                  ForEach(this.loginTypeList, (item: ResourceStr, index: number) => {
                    Row() {
                      Image(item)
                        .width(30)
                    }
                    .justifyContent(FlexAlign.Center)
                    .border({ radius: '50%', width: 1, color: '#fff' })
                    .width(50)
                    .height(50)
                    .onClick(() => {
                      if (index == 3) {
                        if (!this.isAgree) {
                          this.loginType = 5
                          this.agreementDialogController.open()
                        } else {
                          stack.pushPathByName('AccountLogin', null)
                        }
                      }
                    })
                  })
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceAround)
              }
              .offset({ y: this.offsetY })
              .animation({
                duration: 200,
                curve: Curve.EaseOut
              })
            }

            Row({ space: 3 }) {
              Row() {
                Checkbox()
                  .width(14)
                  .unselectedColor('#fff')
                  .selectedColor('#f00')
                  .select($$this.isAgree)
              }
              .padding({ top: 4 })

              Text('我已阅读并同意《用户服务协议》及《隐私协议》，未注册用户登录后将自动创建番茄账号')
                .layoutWeight(1)
                .fontSize(12)
                .fontColor('#fff')
                .lineHeight(22)
            }
            .alignItems(VerticalAlign.Top)
            .width('100%')
            .offset({ y: this.offsetY })
            .animation({
              duration: 200,
              curve: Curve.EaseOut
            })
          }
          .padding(30)
          .width('100%')

        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}