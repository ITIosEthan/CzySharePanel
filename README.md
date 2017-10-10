#### [自定义分享面板，将相关的appKey，appSecret替换为自己对应的信息 点击个平台可进行分享]
#### 使用
```
    /**显示分享面板
     @param 分享平台名称
     @param 分享平台图片
     @param 文字颜色
     @param 文字字体
     */
    [[CzyPopView shareManager] showSharePanelWithTitiles:self.titles
                                           andImageNames:self.titles
                                            andTextColor:[UIColor redColor]
                                             andTextFont:[UIFont systemFontOfSize:12]];
```

#### 效果图
![自定义的分享面板](https://github.com/ITIosEthan/CzySharePanel/blob/master/pop.gif)
