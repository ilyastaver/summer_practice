import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.value;
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _checked = !_checked;
          widget.onChanged?.call(_checked);
        });
      },
      child: Container(
        width: 24,
        height: 24,

        child: _checked
            ? SvgPicture.asset(
          'lib/assets/active_checkbox.svg',

        )
            : SvgPicture.asset('lib/assets/checkbox.svg'),
      ),
    );
  }
}
