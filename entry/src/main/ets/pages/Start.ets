import data from '../../../mock/userAgreementData.json'
import { common } from '@kit.AbilityKit'
import stack from '../utils/route'

@Builder
export function StartBuilder() {
  Start()
}

@ComponentV2
struct Start {
  @Local agreement: Record<string, string[]> = {
    'summary': []
  }
  private pathStack: NavPathStack = new NavPathStack()
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  startDialog: CustomDialogController = new CustomDialogController({
    builder: this.startDialogBuilder,
    width: 300,
    autoCancel: false,
    cornerRadius: 8
  })

  @Builder
  startDialogBuilder() {
    Column({ space: 20 }) {
      Text('欢迎使用番茄免费小说')
        .width('100%')
        .fontSize(18)
        .fontWeight(500)
        .textAlign(TextAlign.Center)
        .fontColor('#030303')
      List({ space: 15 }) {
        ForEach(this.agreement['summary'], (text: string, index: number) => {
          ListItem() {
            if (index == 1) {
              Text() {
                Span('1.你可以查看完整版')
                Span('《用户协议》')
                  .decoration({
                    type: TextDecorationType.Underline,
                    color: '#030303'
                  })
                  .fontColor('#030303')
                Span('和')
                Span('《隐私政策》')
                  .decoration({
                    type: TextDecorationType.Underline,
                    color: '#030303'
                  })
                  .fontColor('#030303')
                Span('以便了解我们收集、使用、共享、存储信息的情况，以及对信息的保护措施。')
              }
              .lineHeight(22)
              .fontColor('#434343')
            } else {
              Text(text)
                .lineHeight(22)
                .fontColor('#434343')
            }
          }
        })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height(200)

      Column({ space: 10 }) {
        Text('不同意')
          .fontColor('#9a9a9a')
          .fontWeight(300)
          .fontSize(14)
          .onClick(() => {
            this.context.terminateSelf()
          })
        Button('同意并继续')
          .width('100%')
          .backgroundColor('#f86724')
          .fontColor('#fff')
          .fontSize(18)
          .fontWeight(600)
          .padding(5)
          .onClick(() => {
            this.startDialog.close()
            stack.replacePathByName('Login', null)
          })
      }
    }
    .padding({
      left: 20,
      right: 20,
      top: 40,
      bottom: 20
    })
  }

  aboutToAppear(): void {
    this.agreement['summary'] = data.agreementData.summary
    setTimeout(() => {
      this.startDialog.open()
    }, 500)
  }

  build() {
    NavDestination() {
      Column() {
        Image($r('app.media.start'))
          .width('100%')
          .objectFit(ImageFit.Fill)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      }
      .height('100%')
      .width('100%')
    }
  }
}