import 'package:elastic_dashboard/services/globals.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_color_picker.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_text_input.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDialog extends StatefulWidget {
  final SharedPreferences preferences;

  final Function(String? data)? onIPAddressChanged;
  final Function(String? data)? onTeamNumberChanged;
  final Function(bool value)? onUseTeamNumberToggle;
  final Function(Color color)? onColorChanged;
  final Function(bool value)? onGridToggle;
  final Function(String? gridSize)? onGridSizeChanged;

  const SettingsDialog({
    super.key,
    required this.preferences,
    this.onTeamNumberChanged,
    this.onUseTeamNumberToggle,
    this.onIPAddressChanged,
    this.onColorChanged,
    this.onGridToggle,
    this.onGridSizeChanged,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    Color currentColor = Color(
        widget.preferences.getInt('team_color') ?? Colors.blueAccent.value);

    return AlertDialog(
      title: const Text('Settings'),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: DialogTextInput(
                    initialText: widget.preferences
                        .getInt(PrefKeys.teamNumber)
                        .toString(),
                    label: 'Team Number',
                    onSubmit: (data) {
                      setState(() {
                        widget.onTeamNumberChanged?.call(data);
                      });
                    },
                    formatter:
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                  ),
                ),
                Flexible(
                  child: DialogColorPicker(
                    onColorPicked: (color) =>
                        widget.onColorChanged?.call(color),
                    label: 'Team Color',
                    initialColor: currentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 75),
                        child: const Text('Use Team # for IP',
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(width: 5),
                      DialogToggleSwitch(
                          key: const ValueKey('Use Team # for IP'),
                          onToggle: (value) {
                            setState(() {
                              widget.onUseTeamNumberToggle?.call(value);
                            });
                          },
                          initialValue: widget.preferences
                                  .getBool(PrefKeys.useTeamNumberForIP) ??
                              false),
                    ],
                  ),
                ),
                Flexible(
                  child: DialogTextInput(
                    enabled: !(widget.preferences
                            .getBool(PrefKeys.useTeamNumberForIP) ??
                        false),
                    initialText:
                        widget.preferences.getString(PrefKeys.ipAddress),
                    label: 'IP Address',
                    onSubmit: (String? data) {
                      setState(() {
                        widget.onIPAddressChanged?.call(data);
                      });
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Show Grid'),
                      const SizedBox(width: 5),
                      DialogToggleSwitch(
                        key: const ValueKey('Show Grid'),
                        initialValue:
                            widget.preferences.getBool(PrefKeys.showGrid) ??
                                false,
                        onToggle: (value) {
                          setState(() {
                            widget.onGridToggle?.call(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: DialogTextInput(
                    initialText: widget.preferences
                            .getInt(PrefKeys.gridSize)
                            ?.toString() ??
                        Globals.gridSize.toString(),
                    label: 'Grid Size',
                    onSubmit: (value) {
                      setState(() {
                        widget.onGridSizeChanged?.call(value);
                      });
                    },
                    formatter:
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
