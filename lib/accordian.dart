import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final Widget expandableChild;
  final Widget headerChild;
  final BoxDecoration decoration;
  final Function onTap;
  Accordion({this.expandableChild, this.headerChild, this.decoration, this.onTap});

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void toggleExpand() {
    if (isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: widget.decoration,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
              toggleExpand();
              if (widget.onTap != null) {
                widget.onTap();
              }
            },
            child: widget.headerChild,
          ),
          SizeTransition(axisAlignment: 1.0, sizeFactor: animation, child: widget.expandableChild),
        ],
      ),
    );
  }
}