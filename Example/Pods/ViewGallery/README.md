# ViewGallery

## Flex Layout

弹性盒子（flexbox，本文档中的 flexbox 与代码中的 flex layout 同意）定义了一种针对用户界面设计而优化的盒子模型。在弹性布局模型中，弹性容器的子元素可以在任何方向上排布，也可以“弹性伸缩”其尺寸，既可以增加尺寸以填满未使用的空间，也可以收缩尺寸以避免父元素溢出。子元素的水平对齐和垂直对齐都能很方便的进行操控。通过嵌套这些框（水平框在垂直框内，或垂直框在水平框内）可以在两个维度上构建布局。

弹性盒子是一种一维的布局，是因为一个 flexbox 一次只能处理一个维度上的元素布局，一行或者一列。

### Flexbox 的两根轴线

当使用 flex 布局时，首先想到的是两根轴线 — 主轴和交叉轴。主轴由 `flexDirection` 定义，另一根轴垂直于它。我们使用 flexbox 的所有属性都跟这两根轴线有关，所以有必要在一开始首先理解它。

| flexDirection | 轴 |
| --- | --- |
| **column**（默认值） | <img src="Documents/Images/axis-column.png" width="200"/> |
| **row** | <img src="Documents/Images/axis-row.png" width="200"/> |

### Flex 容器

文档中采用了 flexbox 的区域就叫做 flex 容器（flex container）。我们已经预定义了2个 Flex 容器，`FlexView` 与 `FlexScrollView`，分别用于不可滚动和可以滚动的场景。
#### Flex 视图

添加在 Flex 容器上的视图被称为 Flex 视图，Flex 容器也是一个 Flex 视图。每个 Flex 视图都有一个与其关联的 `FlexLayout` 对象。Flex 容器可用通过 `.flexLayout` 属性获取。

### 添加 Flex 容器

**方法:**

分别用于添加 `row` 和 `column `容器。

1. `addRow(children: (FlexView) -> Void) -> FlexView`
1. `addRow(style: (FlexLayout) -> Void, children: (FlexView) -> Void) -> FlexView`
1. `addColumn(children: (FlexView) -> Void) -> FlexView`
1. `addColumn(style: (FlexLayout) -> Void, children: (FlexView) -> Void) -> FlexView`

**示例：**

```swift
let row = addRow { style in
    style.positionType(.absolute)
        .height(24.0)
        .minWidth(24.0)
        .justifyContent(.center)
} children: { row in
    row.addItem(textLabel) { style in
        style.autoSize(of: textLabel)
            .margin(horizontal: 6)
    }
}
row.backgroundColor = UIColor.red
```

### 添加 Flex 视图

**方法：**

1. `addItem(_ view: FlexContainerView)`
1. `addItem(_ view: View, style: (FlexLayout) -> Void) -> View where View: UIView`
1. `addItem(_ view: View, style: (FlexLayout) -> Void, children: (View) -> Void) -> View where View: UIView`

**示例：**

```swift
view.addItem(UIView(frame: .zero)) { style in
    style.width(100)
        .aspectRatio(1)
}
```

### flexStyle

用于设置 Flex 视图的样式（`FlexLayout`的属性）。

**方法：**

1. `flexStyle(_ style: (FlexLayout) -> Void) -> Self`
1. `flexStyle(of view: UIView, _ style: (FlexLayout) -> Void)`

### [FlexDirection](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-direction)

**方法：**

* flexDirection(_ value: FlexDirection)

`flexDirection` 属性指定了内部元素是如何在 flex 容器中布局的，定义了主轴的方向 (正方向或反方向)。


| Value | Result | Description |
|---------------------|:------------------:|---------|
| **column**（默认值） 	| <img src="Documents/Images/flexlayout-direction-column.png" width="100"/>| 从上到下 |
| **columnReverse** | <img src="Documents/Images/flexlayout-direction-columnReverse.png" width="100"/>| 从下到上 |
| **row** | <img src="Documents/Images/flexlayout-direction-row.png" width="190"/>| 与文本方向相同 |
| **rowReverse** | <img src="Documents/Images/flexlayout-direction-rowReverse.png" width="190"/>| 与文本方向相反 |


**示例：**

```swift
  flex.direction(.column)  // 默认值。
  flex.direction(.row)
```

### [AlignContent](https://developer.mozilla.org/zh-CN/docs/Web/CSS/align-content)

`alignContent` 属性设置了如何沿着弹性盒子布局的纵轴和网格布局的主轴在内容项之间和周围分配空间。

**方法：**

* `alignContent(_ value: AlignContent)`

|                     	| direction(.column) | direction(.row) | |
|---------------------	|:------------------:|:---------------:| :-: |
| **start**（默认值） 	| <img src="Documents/Images/flexlayout-alignItems-column-flexStart.png" width="140"/>| <img src="Documents/Images/flexlayout-alignItems-row-flexStart.png" width="160"/>| 最先放置项目 |
| **end**	| <img src="Documents/Images/flexlayout-alignItems-column-flexEnd.png" width="140"/>| <img src="Documents/Images/flexlayout-alignItems-row-flexEnd.png" width="160"/>| 最后放置项目 |
| **center** 	| <img src="Documents/Images/flexlayout-alignItems-column-center.png" width="140"/>| <img src="Documents/Images/flexlayout-alignItems-row-center.png" width="160"/>| 居中排列 |
| **stretch**	| <img src="Documents/Images/flexlayout-alignItems-column-stretch.png" width="140"/>| <img src="Documents/Images/flexlayout-alignItems-row-stretch.png" width="160"/>| 均匀分布项目，拉伸自动大小的项目以充满容器 |
| **spaceBetween** | <img src="Documents/Images/flexlayout-alignItems-column-spaceBetween.png" width="160"/> | <img src="Documents/Images/flexlayout-alignItems-row-spaceBetween.png" width="160"/>| 均匀分布项目，第一项与起始点齐平，最后一项与终止点齐平 |
| **spaceAround** | <img src="Documents/Images/flexlayout-alignItems-column-spaceAround.png" width="160"/> | <img src="Documents/Images/flexlayout-alignItems-row-spaceAround.png" width="160"/>| 均匀分布项目，项目在两端有一半大小的空间 |

### [JustifyContent](https://developer.mozilla.org/zh-CN/docs/Web/CSS/justify-content)

`justifyContent` 属性定义了如何分配顺着弹性容器主轴的元素之间及其周围的空间。

**方法：**

* `justifyContent(_ value: JustifyContent)`

|                     	| direction(.column) | direction(.row) | |
|---------------------	|:------------------:|:---------------:|:--|
| **start**（默认值） 	| <img src="Documents/Images/flexlayout-justify-column-flexstart.png" width="140"/>| <img src="Documents/Images/flexlayout-justify-row-flexstart.png" width="160"/>| 从行首起始位置开始排列 |
| **end**	| <img src="Documents/Images/flexlayout-justify-column-flexend.png" width="140"/>| <img src="Documents/Images/flexlayout-justify-row-flexend.png" width="160"/>| 从行尾位置开始排列 |
| **center** 	| <img src="Documents/Images/flexlayout-justify-column-center.png" width="140"/>| <img src="Documents/Images/flexlayout-justify-row-center.png" width="160"/>| 居中排列 |
| **spaceBetween** 	| <img src="Documents/Images/flexlayout-justify-column-spacebetween.png" width="140"/>| <img src="Documents/Images/flexlayout-justify-row-spacebetween.png" width="160"/> | 均匀排列每个元素，首个元素放置于起点，末尾元素放置于终点 |
| **spaceAround** 	| <img src="Documents/Images/flexlayout-justify-column-spacearound.png" width="140"/> | <img src="Documents/Images/flexlayout-justify-row-spacearound.png" width="160"/> | 均匀排列每个元素，每个元素周围分配相同的空间 |
| **spaceEvenly** 	| <img src="Documents/Images/flexlayout-justify-column-spaceevenly.png" width="140"/> | <img src="Documents/Images/flexlayout-justify-row-spaceevenly.png" width="160"/> | 均匀排列每个元素，每个元素之间的间隔相等 |

### [AlignItems](https://developer.mozilla.org/zh-CN/docs/Web/CSS/align-items)

`alignItems` 属性将所有直接子节点上的 `alignSelf` 值设置为一个组。`alignSelf` 属性设置项目在其包含块中在交叉轴方向上的对齐方式。

**方法：**

* alignItems(_ value: AlignItems)


|                     	| direction(.column) | direction(.row) |
|---------------------	|:------------------:|:---------------:|
| **stretch**（默认值） 	| <img src="Documents/Images/flexlayout-align-column-stretch.png" width="140"/>| <img src="Documents/Images/flexlayout-align-row-stretch.png" width="160"/>|
| **start**	| <img src="Documents/Images/flexlayout-align-column-flexStart.png" width="140"/>| <img src="Documents/Images/flexlayout-align-row-flexStart.png" width="160"/>|
| **end**	| <img src="Documents/Images/flexlayout-align-column-flexEnd.png" width="140"/>| <img src="Documents/Images/flexlayout-align-row-flexEnd.png" width="160"/>|
| **center** 	| <img src="Documents/Images/flexlayout-align-column-center.png" width="140"/>| <img src="Documents/Images/flexlayout-align-row-center.png" width="160"/>|

### [AlignSelf](https://developer.mozilla.org/zh-CN/docs/Web/CSS/align-self)

`alignSelf` 会对齐当前 flex 行中的元素，并覆盖已有的 `alignItems` 的值。在 Flexbox 中，会按照交叉轴（cross axis）进行排列。

**方法：**

* alignSelf(_ value: AlignSelf)

### [FlexWrap](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-wrap)

`flexWrap` 属性指定 flex 元素单行显示还是多行显示。如果允许换行，这个属性允许你控制行的堆叠方向。

**方法：**

* flexWrap(_ value: FlexWrap)


|                     	| direction(.column) | direction(.row) | Description|
|---------------------	|:------------------:|:---------------:|--------------|
| **noWrap**（默认值） 	| <img src="Documents/Images/flexlayout-wrap-column-nowrap.png" width="130"/>| <img src="Documents/Images/flexlayout-wrap-row-nowrap.png" width="180"/>| flex 的元素被摆放到到一行，这可能导致 flex 容器溢出 |
| **wrap** | <img src="Documents/Images/flexlayout-wrap-column-wrap.png" width="130"/>| <img src="Documents/Images/flexlayout-wrap-row-wrap.png" width="180"/>| flex 元素 被打断到多个行中 |
| **wrapReverse**	| <img src="Documents/Images/flexlayout-wrap-column-wrapReverse.png" width="130"/>| <img src="Documents/Images/flexlayout-wrap-row-wrapReverse.png" width="180"/>| 和 wrap 的行为一样，但是方向相反 |

### AutoSize

用于计算 `UILable`，`UITextField` 或者任意 `UIView` 自身的大小。使用其 `sizeThatFits(_:CGSize)` 方法。
该方法内部已经处理循环引用的问题，可安全使用。

**方法：**

* autoSize(of view: UIView)

**示例：**

```swift
rootView.addItem(label) { style in
    style.autoSize(of: label)
}
```

## 参考

1. [FlexLayout](https://github.com/layoutBox/FlexLayout) FlexView 参考对象
1. [Yoga](https://yogalayout.com/) 底层布局引擎
