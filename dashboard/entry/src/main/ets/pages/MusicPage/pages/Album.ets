@Component
export struct Album {
  private albums: Resource[] = [];
  private currentIndex: number = 0;
  private onSwipe: (index: number) => void = () => {};
  
  build() {
    Swiper() {
      ForEach(this.albums, (album: Resource) => {
        Image(album)
          .width('100%')
          .borderRadius(8)
      })
    }
    .index(this.currentIndex)
    .autoPlay(true)
    .interval(3000)
    .indicator(true)
    .onChange((index: number) => {
      this.onSwipe(index);
    })
  }
}