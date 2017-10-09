#### [自定义分享面板，将相关的appKey，appSecret替换为自己对应的信息 点击个平台可进行分享]
#### 使用
```
    CzyPopView *popView = [[CzyPopView alloc] init];
    popView.frame = self.view.bounds;
    [self.view addSubview:popView];
    
    /**设置分享按钮UI*/
    popView.imageNames = self.titles;
    popView.titles = self.titles;
    
    /**设置分享平台名称字体和颜色*/
    popView.textColor = [UIColor redColor];
    popView.textFont = [UIFont systemFontOfSize:12];
```

#### 效果图
![自定义的分享面板](https://github.com/ITIosEthan/CzySharePanel/blob/master/pop.gif)
