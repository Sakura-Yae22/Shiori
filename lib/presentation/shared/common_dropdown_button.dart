import 'package:flutter/material.dart';
import 'package:shiori/presentation/shared/utils/enum_utils.dart';

class CommonDropdownButton<T> extends StatelessWidget {
  final String hint;
  final T? currentValue;
  final List<TranslatedEnum<T>> values;
  final Function(T, BuildContext)? onChanged;
  final bool isExpanded;
  final bool withoutUnderLine;
  final Widget Function(T)? leadingIconBuilder;

  const CommonDropdownButton({
    super.key,
    required this.hint,
    this.currentValue,
    required this.values,
    this.onChanged,
    this.isExpanded = true,
    this.withoutUnderLine = true,
    this.leadingIconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      isExpanded: isExpanded,
      dropdownColor: Theme.of(context).cardColor,
      hint: Text(hint),
      value: currentValue,
      underline: withoutUnderLine
          ? Container(
              height: 0,
              color: Colors.transparent,
            )
          : null,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      onChanged: onChanged != null ? (v) => onChanged!(v as T, context) : null,
      selectedItemBuilder: (context) => values
          .map(
            (lang) => Align(
              alignment: Alignment.centerLeft,
              child: Text(lang.translation, textAlign: TextAlign.center),
            ),
          )
          .toList(),
      items: values
          .map<DropdownMenuItem<T>>(
            (lang) => DropdownMenuItem<T>(
              value: lang.enumValue,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: lang.enumValue != currentValue ? const SizedBox(width: 20) : const Center(child: Icon(Icons.check, size: 20)),
                  ),
                  if (leadingIconBuilder != null) leadingIconBuilder!.call(lang.enumValue),
                  Expanded(
                    child: Text(
                      lang.translation,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
