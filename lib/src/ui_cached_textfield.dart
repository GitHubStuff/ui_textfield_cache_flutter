import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ui_marquee_flutter/ui_marguee_flutter.dart';

import '../ui_textfield_cache_flutter.dart';

const Color _kDarkModeBgColor = Colors.deepPurple;
const Color _kDarkModeEvenColor = Color(0xFF404040);
const Color _kDarkModeOddColor = Color(0xFF303030);
const Color _kDarkModeTextColor = Colors.yellow;
const Color _kLightModeBgColor = Color(0xFFB3E5FC);
const Color _kLightModeEvenColor = Color(0xffeeeeee);
const Color _kLightModeOddColor = Color(0xffe0e0e0);
const Color _kLightModeTextColor = Colors.black;

/// A stateful widget that provides a text input field with caching capabilities.
///
/// This widget integrates with a caching mechanism to store and display a list
/// of previously entered text values. It is designed to enhance user experience
/// by offering quick access to recent entries and facilitating easy selection.
/// The widget uses a [UITextFieldCubit] for state management to handle the
/// addition, display, and sorting of cached strings.
class UICachedTextField extends StatefulWidget {
  /// A callback function that is invoked with the selected or entered text.
  ///
  /// This function is called when the user accepts the input value, allowing
  /// the parent widget to receive and process the selected or newly entered text.
  final Function(String?) callback;

  /// Constructs an instance of [UICachedTextField].
  ///
  /// Requires a [callback] function to handle the user's text input or selection.
  const UICachedTextField({
    super.key,
    required this.callback,
  });

  @override
  State<UICachedTextField> createState() => _UICachedTextField();
}

class _UICachedTextField extends State<UICachedTextField> {
  // Focus node to manage keyboard focus for the text input field.
  final FocusNode focusNode = FocusNode();
  // Controller for the text input field to manage text entry and updates.
  final TextEditingController controller = TextEditingController();
  // Scroll controller for the list view to manage list scrolling.
  final ScrollController scrollController = ScrollController();
  // Cubit for managing the state of the UI and cached text entries.
  late final UITextFieldCubit cubit;
  // Flag to determine if the dark mode theme is enabled.
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    // Request focus for the text input field after the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    // Listener to handle text changes and update the UI accordingly.
    controller.addListener(onTextChanged);
    // Initialize the cubit responsible for managing text entries.
    cubit = Modular.get<UITextFieldCubit>();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is enabled based on the theme context.
    isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    return Column(children: [
      const SizedBox(height: 15),
      textInput(),
      cacheList(),
      buildButtons(),
    ]);
  }

  @override
  void dispose() {
    // Dispose of controllers and focus node to release resources.
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// Builds and returns a widget containing action buttons for the form.
  ///
  /// This method creates buttons for accepting or canceling the text input,
  /// applying appropriate styles based on the current theme (dark or light mode).
  Widget buildButtons() {
    // Define the style for the buttons, adapting to the theme.
    final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          // Choose color based on the theme.
          return (isDarkMode) ? _kDarkModeBgColor : _kLightModeBgColor;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          // Choose text color based on the theme.
          return (isDarkMode) ? _kDarkModeTextColor : _kLightModeTextColor;
        },
      ),
    );

    // Layout for the Accept and Cancel buttons.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: buttonStyle,
          onPressed: () async {
            // Add the entered text to the cubit and invoke the callback.
            await cubit.addItem(controller.text);
            widget.callback(controller.text);
            dismissKeyboard();
          },
          child: const Text('Accept'),
        ),
        ElevatedButton(
          style: buttonStyle,
          onPressed: () {
            // Invoke the callback with null to indicate cancellation.
            widget.callback(null);
            dismissKeyboard();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  /// Builds and returns the list widget displaying cached text entries.
  ///
  /// This method uses a [BlocBuilder] to reactively update the list view
  /// based on the state managed by [UITextFieldCubit]. It displays cached
  /// entries and allows users to select a previous entry to fill the text field.
  Widget cacheList() {
    // BlocBuilder to rebuild the UI based on the current state of cached entries.
    return BlocBuilder<UITextFieldCubit, List<String>>(
      bloc: cubit,
      builder: (context, state) {
        // A scrollable list view of cached entries.
        return SizedBox(
          height: 160,
          child: ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: state.length,
              itemBuilder: (context, index) {
                // Determine the background and text color based on the index and theme.
                Color backgroundColor = (index % 2 == 0)
                    ? (isDarkMode
                        ? _kDarkModeEvenColor
                        : _kLightModeEvenColor) // Even items
                    : (isDarkMode
                        ? _kDarkModeOddColor
                        : _kLightModeOddColor); // Odd items
                // Each entry in the list.
                return InkWell(
                  onTap: () {
                    // Set the text field to the selected entry and sort the list.
                    controller.text = state[index];
                    cubit.newSort(state[index]);
                  },
                  child: Container(
                    color: backgroundColor,
                    height: 40.0, // Height for each row
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    // Marquee widget for scrolling long text entries.
                    child: UIMarqueeWidget(
                      message: state[index].replaceAll('\n', ' '),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  /// Dismisses the keyboard by changing the focus to a new FocusNode.
  void dismissKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  /// Invoked when the text in the input field changes.
  ///
  /// This method triggers the cubit to sort the list based on the new input
  /// and ensures the list view scrolls to the top to display the most relevant entries.
  void onTextChanged() {
    cubit.newSort(controller.text);
    jumpToTop();
  }

  /// Scrolls the list view to the top after a short delay.
  void jumpToTop() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(50);
      }
    });
  }

  /// Builds and returns the text input field widget.
  ///
  /// This method configures the text input field with a controller, focus node,
  /// and decorative elements like borders and labels.
  Widget textInput() {
    return TextField(
      style: const TextStyle(
          //color: isDarkMode ? _kDarkModeListViewText : _kLightModeListViewText,
          ),
      maxLines: 4,
      controller: controller,
      focusNode: focusNode,
      decoration: const InputDecoration(
        //filled: true,
        //fillColor: isDarkMode ? Colors.black87 : Colors.white,
        border: OutlineInputBorder(),
        labelText: 'Enter text',
        //labelStyle:
        //TextStyle(color: isDarkMode ? _kDarkModePrompt : _kLightModePrompt),
      ),
    );
  }
}
