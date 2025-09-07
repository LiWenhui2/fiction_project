import { Books } from './Books'
import { Find } from './Find'
import { My } from './My'
import { Shelf } from './Shelf'
import { Welfare } from './Welfare'

interface NavListType {
  icon: ResourceStr
  text: string
}

@Builder
export function HomeBuilder() {
  Home()
}

@Component
struct Home {
  @State currentIndex: number = 0
  @State navList: NavListType[] = [
    {
      icon: $r('app.media.navIcon_books'),
      text: '书城'
    },
    {
      icon: $r('app.media.navIcon_bookshelf'),
      text: '书架'
    },
    {
      icon: $r('app.media.navIcon_welfare'),
      text: '福利'
    },
    {
      icon: $r('app.media.navIcon_find'),
      text: '发现'
    },
    {
      icon: $r('app.media.navIcon_my'),
      text: '我的'
    },
  ]

  @Builder
  toolBar() {
    ForEach(this.navList, (item: NavListType, index: number) => {
      Column({ space: 5 }) {
        Image(item.icon)
          .width(22)
          .fillColor(this.currentIndex == index ? '#35a9ff' : '#1b1b1b')
        Text(item.text)
          .fontSize(14)
          .fontColor(this.currentIndex == index ? '#35a9ff' : '#1b1b1b')
      }
      .width('20%')
      .onClick(() => {
        this.currentIndex = index
      })

    })
  }

  build() {
    NavDestination() {
      if (this.currentIndex == 0) {
        Books()
      } else if (this.currentIndex == 1) {
        Shelf()
      } else if (this.currentIndex == 2) {
        Welfare()
      } else if (this.currentIndex == 3) {
        Find()
      } else {
        My()
      }
    }
    .backgroundColor('#f2f4fa')
    .toolbarConfiguration(this.toolBar,
      {
        backgroundColor: '#fff'
      })
    .hideBackButton(true)
  }
}