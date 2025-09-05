import axios from '../../utils/HttpRequest';
import stack from '../../utils/route';

@Builder
export function AccountLoginBuilder() {
  AccountLogin()
}

@Extend(Row)
function PhoneLoginRowStyle() {
  .padding({ left: 20, right: 15 })
  .height(50)
  .width('100%')
  .backgroundColor('#fff')
  .borderRadius(25)
  .borderWidth(1)
  .borderColor('#999')
}

@Extend(TextInput)
function textInputStyle() {
  .borderRadius(0)
  .caretColor('#cecece')
  .placeholderColor('#cecece')
  .placeholderFont({ weight: 500 })
  .backgroundColor(Color.Transparent)
  .padding(0)
  .layoutWeight(1)
}

@Component
struct AccountLogin {
  @State account: string = ''
  @State password: string = ''
  @State alertMessage: string = ''
  @StorageLink('token') token: string = ''
  @State isAccountLegal: boolean = false
  @State isPasswordLegal: boolean = false
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

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('番茄账号登录')
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

      Column({ space: 20 }) {
        Row({ space: 10 }) {
          Image($r('app.media.account_login_user'))
            .width(20)
          TextInput({ placeholder: '手机号/邮箱/番茄账号', text: $$this.account })
            .textInputStyle()
            .onChange(() => {
              this.isAccountLegal = this.account != ''
            })
        }
        .PhoneLoginRowStyle()

        Row({ space: 10 }) {
          Image($r('app.media.account_login_pwd'))
            .width(22)
          TextInput({ placeholder: '密码', text: $$this.password })
            .textInputStyle()
            .type(InputType.Password)
            .onChange(() => {
              this.isPasswordLegal = this.password != ''
            })
        }
        .PhoneLoginRowStyle()

        Row() {
          Text('登录')
            .fontColor('#fff')
            .fontSize(18)
            .fontWeight(600)
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .PhoneLoginRowStyle()
        .borderColor(Color.Transparent)
        .backgroundColor(this.isPasswordLegal && this.isAccountLegal ? '#e4363f' : '#e0e0e0')


        .onClick(async () => {
          if (this.account == '' || this.password == '') {
            this.alertMessage = '账号或密码不能为空'
            this.dialogOpen()
            return
          }
          try {
            const res = await axios.post<Record<string, string>>('/user/login', {
              'account': this.account,
              'password': this.password
            })
            if (res['status'] == 1) {
              this.alertMessage = res['message'] || '登录失败'
              this.dialogOpen()
              return
            }
            this.token = res['token']
            console.log('login success')
          } catch (e) {
            console.log(e)
          }

        })

        Row() {
          Text('忘记密码？')
            .fontColor('#858585')
            .onClick(() => {
              stack.pushPathByName('ResetPwd', '')
            })
          Text('注册新账号')
            .fontColor('#1b1b1b')
            .onClick(() => {
              stack.pushPathByName('Register', null)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .backgroundColor('#e9e9e9')
    .padding(20)
    .hideBackButton(true)
  }
}