import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class CodeInput extends StatefulWidget {
  const CodeInput({
    required this.length,
    required this.value,
    required this.onChanged,
    super.key,
    this.hasError = false,
    this.enabled = true,
  });

  final int length;
  final String value;
  final ValueChanged<String> onChanged;
  final bool hasError;
  final bool enabled;

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_refresh);
  }

  @override
  void didUpdateWidget(CodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _focus
      ..removeListener(_refresh)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _focus.hasFocus ? widget.value.length : -1;
    return Semantics(
      label: '${widget.length}-digit code',
      value: widget.value,
      textField: true,
      child: Stack(
        children: [
          ExcludeSemantics(
            child: Row(
              spacing: Spacing.xs,
              children: [
                for (var i = 0; i < widget.length; i++)
                  _DigitBox(
                    digit: i < widget.value.length ? widget.value[i] : '',
                    active: i == active,
                    error: widget.hasError,
                  ).expand(),
              ],
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                enabled: widget.enabled,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                maxLength: widget.length,
                showCursor: false,
                enableInteractiveSelection: false,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DigitBox extends StatelessWidget {
  const _DigitBox({
    required this.digit,
    required this.active,
    required this.error,
  });

  final String digit;
  final bool active;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final ring = error
        ? sp.primary
        : active
        ? sp.primary
        : sp.line;
    return AnimatedContainer(
      duration: context.motion(Motion.small),
      curve: Motion.arrive,
      height: 60,
      decoration: BoxDecoration(
        color: sp.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ring, width: active || error ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: AppText(text: digit, config: FontConfigs.h2),
    );
  }
}
