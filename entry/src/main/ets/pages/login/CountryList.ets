import data from '../../../../mock/countryCodeAndPhoneCode.json'
import stack from '../../utils/route'

@Builder
export function CountryListBuilder() {
  CountryList()
}

@ComponentV2
struct CountryList {
  @Local groups: string[] = []
  @Local selected: number = 0
  private listScroll: Scroller = new Scroller()

  aboutToAppear(): void {
    const set: Set<string> = new Set()
    for (const country of data.countryList) {
      set.add(country.pinyin[0].toUpperCase())
    }
    this.groups = Array.from(set).sort()
    console.log(JSON.stringify(this.groups))
  }

  @Builder
  header(group: string) {
    Row() {
      Text(group)
        .fontColor('#8a8b8f')
        .fontSize(14)
    }
    .padding({ left: 12 })
    .height(30)
    .width('100%')
    .backgroundColor('#f6f7fb')
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('国家/地区')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor('#131313')
          .fontSize(18)
          .fontWeight(600)
        Image($r('app.media.backButton'))
          .width(18)
      }
      .padding(15)
      .height(50)

      Stack({ alignContent: Alignment.End }) {
        List({ scroller: this.listScroll }) {
          ForEach(this.groups, (group: string) => {
            ListItemGroup({ header: this.header(group) }) {
              ForEach(data.countryList.filter(item => item.pinyin.startsWith(group.toLowerCase())),
                (country: Record<string, string>) => {
                  ListItem() {
                    Column() {
                      Text(country['chinese_name'])
                        .height(40)
                        .width('100%')
                        .onClick(() => {
                          stack.pop({name:country['chinese_name'],code:country['phone_code']})
                        })
                      Divider().strokeWidth(1).color('#fff9f9f9')
                    }
                    .padding({ left: 15, right: 15 })
                  }

                })
            }
          })
        }
        .sticky(StickyStyle.Header)
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
        .onScrollIndex((start) => {
          this.selected = start
        })

        AlphabetIndexer({ arrayValue: this.groups, selected: 0 })
          .selected(this.selected)
          .onSelect((index) => {
            this.listScroll.scrollToIndex(index)
          })
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .hideBackButton(true)
  }
}