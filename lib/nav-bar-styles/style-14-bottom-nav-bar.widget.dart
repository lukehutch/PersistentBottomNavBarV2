part of persistent_bottom_nav_bar_v2;

class BottomNavStyle14 extends StatefulWidget {
  final NavBarEssentials navBarEssentials;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimationProperties itemAnimationProperties;

  BottomNavStyle14({
    Key? key,
    required this.navBarEssentials,
    this.itemAnimationProperties = const ItemAnimationProperties(
      duration: Duration(milliseconds: 400),
      curve: Curves.ease,
    ),
  });

  @override
  _BottomNavStyle14State createState() => _BottomNavStyle14State();
}

class _BottomNavStyle14State extends State<BottomNavStyle14>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllerList;
  late List<Animation<Offset>> _animationList;

  int? _lastSelectedIndex;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _lastSelectedIndex = 0;
    _selectedIndex = 0;
    _animationControllerList = List<AnimationController>.empty(growable: true);
    _animationList = List<Animation<Offset>>.empty(growable: true);

    for (int i = 0; i < widget.navBarEssentials.items!.length; ++i) {
      _animationControllerList.add(AnimationController(
          duration: widget.itemAnimationProperties.duration ??
              Duration(milliseconds: 400),
          vsync: this));
      _animationList.add(Tween(
              begin: Offset(0, widget.navBarEssentials.navBarHeight! / 1.5),
              end: Offset(0, 0.0))
          .chain(CurveTween(
              curve: widget.itemAnimationProperties.curve ?? Curves.ease))
          .animate(_animationControllerList[i]));
    }

    _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
      _animationControllerList[_selectedIndex!].forward();
    });
  }

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected,
      double? height, int itemIndex) {
    double itemWidth = ((MediaQuery.of(context).size.width -
            ((widget.navBarEssentials.padding?.left ??
                    MediaQuery.of(context).size.width * 0.05) +
                (widget.navBarEssentials.padding?.right ??
                    MediaQuery.of(context).size.width * 0.05))) /
        widget.navBarEssentials.items!.length);
    return widget.navBarEssentials.navBarHeight == 0
        ? SizedBox.shrink()
        : AnimatedBuilder(
            animation: _animationList[itemIndex],
            builder: (context, child) => Container(
              width: 150.0,
              height: height,
              child: Container(
                alignment: Alignment.center,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: IconTheme(
                        data: IconThemeData(
                          size: item.iconSize,
                          color: isSelected
                              ? item.activeColorPrimary
                              : item.inactiveColorPrimary,
                        ),
                        child: isSelected ? item.icon : item.inactiveIcon,
                      ),
                    ),
                    item.title == null
                        ? SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Material(
                              type: MaterialType.transparency,
                              child: FittedBox(
                                child: Text(
                                  item.title!,
                                  style: item.textStyle != null
                                      ? item.textStyle!.apply(
                                          color: isSelected
                                              ? item.activeColorPrimary
                                              : item.inactiveColorPrimary)
                                      : TextStyle(
                                          color: isSelected
                                              ? item.activeColorPrimary
                                              : item.inactiveColorPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0),
                                ),
                              ),
                            ),
                          ),
                    Transform.translate(
                      offset: _animationList[itemIndex].value,
                      child: AnimatedContainer(
                        duration: widget.itemAnimationProperties.duration ??
                            Duration(milliseconds: 400),
                        height: 5.0,
                        width: itemWidth * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: isSelected
                              ? item.activeColorSecondary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.navBarEssentials.items!.length; ++i) {
      _animationControllerList[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.navBarEssentials.items!.length !=
        _animationControllerList.length) {
      _animationControllerList =
          List<AnimationController>.empty(growable: true);
      _animationList = List<Animation<Offset>>.empty(growable: true);

      for (int i = 0; i < widget.navBarEssentials.items!.length; ++i) {
        _animationControllerList.add(AnimationController(
            duration: widget.itemAnimationProperties.duration ??
                Duration(milliseconds: 400),
            vsync: this));
        _animationList.add(Tween(
                begin: Offset(0, widget.navBarEssentials.navBarHeight! / 2.0),
                end: Offset(0, 0.0))
            .chain(CurveTween(
                curve: widget.itemAnimationProperties.curve ?? Curves.ease))
            .animate(_animationControllerList[i]));
      }
    }
    if (widget.navBarEssentials.selectedIndex != _selectedIndex) {
      _lastSelectedIndex = _selectedIndex;
      _selectedIndex = widget.navBarEssentials.selectedIndex;
      _animationControllerList[_selectedIndex!].forward();
      _animationControllerList[_lastSelectedIndex!].reverse();
    }
    return Container(
      width: double.infinity,
      height: widget.navBarEssentials.navBarHeight,
      padding: EdgeInsets.only(
          left: widget.navBarEssentials.padding?.left ??
              MediaQuery.of(context).size.width * 0.04,
          right: widget.navBarEssentials.padding?.right ??
              MediaQuery.of(context).size.width * 0.04,
          top: widget.navBarEssentials.padding?.top ??
              widget.navBarEssentials.navBarHeight! * 0.12,
          bottom: widget.navBarEssentials.padding?.bottom ??
              widget.navBarEssentials.navBarHeight! * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.navBarEssentials.items!.map((item) {
          int index = widget.navBarEssentials.items!.indexOf(item);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.navBarEssentials.items![index].onPressed != null) {
                  widget.navBarEssentials.items![index].onPressed!(
                      widget.navBarEssentials.selectedScreenBuildContext);
                } else {
                  if (index != _selectedIndex) {
                    _lastSelectedIndex = _selectedIndex;
                    _selectedIndex = index;
                    _animationControllerList[_selectedIndex!].forward();
                    _animationControllerList[_lastSelectedIndex!].reverse();
                  }
                  widget.navBarEssentials.onItemSelected!(index);
                }
              },
              child: Container(
                color: Colors.transparent,
                child: _buildItem(
                    item,
                    widget.navBarEssentials.selectedIndex == index,
                    widget.navBarEssentials.navBarHeight,
                    index),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
