## pages/replay/index.vueファイル

```
value: function() {
  if(Math.abs(this.tempValue - this.value) > 1) {
    this.stop()
  }
  this.tempValue = this.value
}
```

直前と1%の差があった場合という意味。
1%とは、30分アニメで18秒、5分アニメで3秒なので、それ以上急に変わる場合はユーザーが操作した時と判断する。
v-on:drag-start="dragStart" とする方法も考えられたが、その場合プログレスバーをクリックしてvalueを変えた場合にイベント発火しなかった。

## 

