@Component
export struct SliderVerification {
  @State sliderValue: number = 20
  @State tipMsg: string = '拖动下方滑块完成拼图'
  @State translateX: number = 0
  @Link verifyStatus: number

  build() {
    Column({ space: 8 }) {
      Stack({ alignContent: Alignment.TopEnd }) {
        Column({ space: 10 }) {
          Text('安全验证')
            .width('100%')
            .fontColor('#999999')
          Text(this.tipMsg)
            .fontColor(this.tipMsg == '验证错误，请重试' ? '#d23842' : '#1c1c1c')
            .fontSize(18)
            .width('100%')
        }
        .width('100%')

        Image($r('app.media.verify_close'))
          .width(26)
          .onClick(() => {
            this.verifyStatus = -1
          })
      }

      Stack() {
        Column({ space: 8 }) {
          Stack({ alignContent: Alignment.Start }) {
            Image($r('app.media.sliderBackground'))
              .width('100%')
            Image($r('app.media.slider'))
              .width('13.34%')
              .translate({ x: this.sliderValue * 2.9 })
          }

          Slider({
            value: $$this.sliderValue,
            step: 1,
            min: 0,
            max: 100,
            style: SliderStyle.InSet
          })
            .selectedColor('#c8c8c8')
            .trackColor('#c8c8c8')
            .trackThickness(20)
            .blockSize({ width: 35, height: 35 })
            .sliderInteractionMode(SliderInteraction.SLIDE_ONLY)
            .blockStyle({ type: SliderBlockType.IMAGE, image: $r('app.media.verify_button') })
            .onChange((val, mode) => {
              if (mode == SliderChangeMode.End) {
                if ([76, 77, 78].includes(val)) {
                  this.verifyStatus = 1
                  setTimeout(() => {
                    this.verifyStatus = 0
                  }, 500)
                } else {
                  this.tipMsg = '验证错误，请重试'
                  this.translateX = 3
                  this.sliderValue = 20
                  setTimeout(() => {
                    this.tipMsg = '拖动下方滑块完成拼图'
                  }, 1000)
                  const timeId = setInterval(() => {
                    this.translateX = 0
                    setTimeout(() => {
                      this.translateX = 3
                    }, 50)
                  }, 100)
                  setTimeout(() => {
                    clearInterval(timeId)
                  }, 400)

                }
              }
            })
        }
        .translate({ x: this.translateX })
        .animation({
          duration: 50,
          curve: Curve.Linear
        })

        if (this.verifyStatus == 1) {
          Row() {
            Column({ space: 10 }) {
              Image($r('app.media.verify_success'))
                .width(50)
              Text('验证成功！')
                .fontColor('#2cce06')
                .fontSize(18)
            }
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .height(240)
          .backgroundColor('rgba(255,255,255,0.8)')
        }
      }

      Row({ space: 15 }) {
        Image($r('app.media.verify_problem'))
          .width(40)
        Image($r('app.media.verify_refresh'))
          .width(24)
      }
      .width('100%')
      .padding({ left: 20 })
    }
    .padding({
      left: 10,
      right: 10,
      top: 15,
      bottom: 15
    })
    .backgroundColor('#fff')
  }
}