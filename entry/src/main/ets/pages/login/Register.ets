import axios from '../../utils/HttpRequest'
import stack from '../../utils/route'

@Builder
export function RegisterBuilder() {
  Register()
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

@Extend(Row)
function PhoneLoginRowStyle() {
  .padding({ left: 20, right: 15 })
  .height(50)
  .width('100%')
  .backgroundColor('#fff')
  .borderRadius(25)
}

@ComponentV2
struct Register {
  @Local phone: string = ''
  @Local email: string = ''
  @Local alertMessage: string = ''
  @Local phone: string = '15502796477'
  @Local email: string = 'vonphy217@gmail.com'
  @Local code: string = ''
  @Local alertMessage: string = ''
  @Local isAllowRegister: boolean = false
  @Local isPhoneLegal: boolean = false
  @Local isEmailLegal: boolean = false
  @Local isCodeLegal: boolean = false
  @Local phoneReg: RegExp = /^1[3-9]\d{9}$/
  @Local emailReg: RegExp = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
  @Local codeReg: RegExp = /^\d{6}$/
  @Local codeCount: number = 60
  @Local codeIsSend: boolean = false
  alertDialogController: CustomDialogController = new CustomDialogController({
    builder: this.alertDialog,
    backgroundColor: '#0f0e13',
    width: 180,
    height: 50,
    cornerRadius: 15,
    isModal: false
  })

  @Builder
  alertDialog() {
    Text(this.alertMessage)
      .fontColor('#fff')
      .padding(15)
      .backgroundColor('#0f0e13')
      .width(180)
      .height(50)
      .fontWeight(500)
      .textAlign(TextAlign.Center)
  }

  dialogOpen() {
    this.alertDialogController.open()
    setTimeout(() => {
      this.alertDialogController.close()
    }, 2000)
  }

  verify(): boolean {
    //验证手机号
    if (!this.phoneReg.test(this.phone)) {
      this.alertMessage = '手机号格式不正确'
      this.dialogOpen()
      return false
    }
    //验证邮箱
    if (!this.emailReg.test(this.email)) {
      this.alertMessage = '邮箱格式不正确'
      this.dialogOpen()
      return false
    }
    if (!this.codeReg.test(this.code)) {
      this.alertMessage = '请输入合法验证码'
      this.dialogOpen()
      return false
    }
    return true
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('账号注册')
          .fontColor('#1b1b1b')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
        Image($r('app.media.backButton'))
          .width(20)
          .onClick(() => {
            stack.pop()
          })
      }
      .margin({ bottom: 20 })

      Column({ space: 15 }) {
        Row({ space: 10 }) {
          Image($r('app.media.login_phone'))
            .width(24)
          Text('+86')
            .fontColor('#1b1b1b')
            .fontWeight(500)
            .margin({ left: 5, right: 5 })

          Image($r('app.media.login_phone_more'))
            .width(12)
          TextInput({ placeholder: '请输入手机号', text: $$this.phone })
            .textInputStyle()
            .onChange(() => {
              this.isPhoneLegal = this.phoneReg.test(this.phone)
            })
        }
        .PhoneLoginRowStyle()

        Row({ space: 10 }) {
          Image($r('app.media.register_email'))
            .width(24)
          TextInput({ placeholder: '请输入邮箱', text: $$this.email })
            .textInputStyle()
            .type(InputType.Email)
            .onChange(() => {
              this.isEmailLegal = this.emailReg.test(this.email)
            })
        }
        .PhoneLoginRowStyle()

        Row({ space: 10 }) {
          Image($r('app.media.login_code'))
            .width(24)
          TextInput({ placeholder: '请输入邮箱验证码', text: $$this.code })
            .textInputStyle()
            .onChange(() => {
              this.isCodeLegal = this.codeReg.test(this.code)
            })

          Divider().strokeWidth(1).color('#cecece').height(25).vertical(true)
          Text(this.codeIsSend ? `已发送(${this.codeCount})` : '获取验证码')
            .fontColor(this.codeIsSend ? '#cecece' : '#921721')
            .onClick(() => {
              if (!this.codeIsSend) {
                this.codeIsSend = true
                const res = axios.post<Record<string, string>>('/verify/registerSend12', { 'email': this.email })
                console.log(JSON.stringify(res))
                const timeId = setInterval(() => {
                  if (this.codeCount <= 0) {
                    this.codeIsSend = false
                    clearInterval(timeId)
                    this.codeCount = 60
                  }
                  this.codeCount--
                }, 1000)
              }
            })
        }
        .PhoneLoginRowStyle()


        Row() {
          Text('注册')
            .fontColor('#fff')
            .fontSize(18)
            .fontWeight(600)
            .width('100%')
            .textAlign(TextAlign.Center)

        }
        .PhoneLoginRowStyle()
        .backgroundColor(this.isPhoneLegal && this.isEmailLegal && this.isCodeLegal ? '#e4363f' : '#e0e0e0')
        .onClick(() => {
          this.verify()
        })
      }
    }
    .backgroundColor('#f5f5f5')
    .padding(20)
    .hideBackButton(true)
  }
}