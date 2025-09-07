import stack from '../../utils/route'
import inputMethod from '@ohos.inputMethod'
import axios from '../../utils/HttpRequest'

@Builder
export function VerificationBuilder() {
  Verification()
}

@Component
struct Verification {
  @State account: string = ''
  @State code: string = ''
  @State isCodeLegal: boolean = false
  @State alertMessage: string = ''
  @State count: number = 60
  @State isCodeAllowSend: boolean = false
  private inputController: inputMethod.InputMethodController = inputMethod.getController()
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.DONE
    }
  }
  alertDialogController: CustomDialogController = new CustomDialogController({
    builder: this.alertDialog,
    backgroundColor: '#0f0e13',
    width: 200,
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
      .width(200)
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

  aboutToAppear(): void {
    this.account = stack.getParamByName('Verification')[0] as string
    this.attach()
    this.resetCodeCount()
    // console.log(stack.getParamByName('Verification')[0] as string)
  }

  resetCodeCount() {
    const timeId = setInterval(() => {
      if (this.count <= 0) {
        clearInterval(timeId)
        this.isCodeAllowSend = true
        this.count = 60
      }
      this.count--
    }, 1000)
  }

  async attach() {
    await this.inputController.attach(true, this.textConfig)
    this.listen()
  }

  listen() {
    this.inputController.on('insertText', (text: string) => {
      if (this.code.length >= 6 || isNaN(Number(text)) || text == ' ') {
        return
      }
      this.code += text
    })
    this.inputController.on('deleteLeft', () => {
      this.code = this.code.slice(0, -1)
    })
  }

  aboutToDisappear(): void {
    this.inputController.off('insertText')
    this.inputController.off('deleteLeft')
    this.inputController.detach(() => {
    })
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('身份验证')
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
      .margin({ bottom: 70 })

      Column({ space: 10 }) {
        Text('请输入验证码')
          .fontSize(24)
          .fontWeight(500)
        Row({ space: 5 }) {
          Text('验证码已发送至')
            .fontColor('#6e6e6e')
            .fontSize(14)
          Text(this.account.replace(this.account.substring(3, 7), '****'))
            .fontSize(14)
            .fontColor('#0a59f7')
        }

        Row() {
          ForEach([0, 1, 2, 3, 4, 5], (item: number) => {
            Text(this.code[item] ?? '')
              .fontWeight(700)
              .width(50)
              .height(50)
              .borderRadius(10)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.code[item] ? '#330a59f7' : '#fff1f3f5')
          }, (item: number) => item.toString())
        }
        .width('100%')
        .margin({ top: 20, bottom: 18 })
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.inputController.attach(true, this.textConfig)
        })
      }

      Text(this.isCodeAllowSend ? '重新获取' : `重新获取(${this.count})`)
        .fontWeight(500)
        .fontColor(this.isCodeAllowSend ? '#0a59f7' : '#999')
        .width('100%')
        .textAlign(TextAlign.End)
        .onClick(async () => {
          if (this.isCodeAllowSend) {
            this.isCodeAllowSend = false
            const sendCodeRes = await axios.post('/verify/sendCode', {
              'email': this.account
            } as Record<string, string>)
            if (sendCodeRes['status'] == 1) {
              this.alertMessage = '验证码发送失败'
              this.dialogOpen()
              return
            }
            this.alertMessage = '验证码发送成功'
            this.dialogOpen()
            this.resetCodeCount()
          }
        })
      Button('验证')
        .fontColor('#fff')
        .fontSize(20)
        .width('100%')
        .height(50)
        .margin({ top: 35 })
        .backgroundColor(this.code.length == 6 ? '#2481fa' : '#d3e5fe')
        .onClick(async () => {
          if (this.code.length == 6) {
            const res = await axios.post('/verify/verifyCode', {
              'code': this.code
            } as Record<string, string>)
            if (res['status'] == 1) {
              this.alertMessage = res['message'] || '验证码错误'
              this.dialogOpen()
              return
            }
            stack.pushPathByName('NewPwd', this.account)
          }
        })
    }
    .padding(20)
    .hideBackButton(true)
  }
}