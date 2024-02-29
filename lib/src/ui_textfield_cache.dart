import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'ui_textfield_cubit.dart';

class UITextFieldCache extends StatefulWidget {
  final Function(String?) callback;

  const UITextFieldCache({
    super.key,
    required this.callback,
  });

  @override
  State<UITextFieldCache> createState() => _UITextFieldCache();
}

class _UITextFieldCache extends State<UITextFieldCache> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late final UITextFieldCubit cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    controller.addListener(onTextChanged);
    cubit = Modular.get<UITextFieldCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 75),
      textInput(),
      cacheList(),
      buildButtons(),
    ]);
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            await cubit.addItem(controller.text);
            widget.callback(controller.text);
            dismissKeyboard();
          },
          child: const Text('Accept'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.callback(null);
            dismissKeyboard();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget cacheList() {
    return BlocBuilder<UITextFieldCubit, List<String>>(
      bloc: cubit,
      builder: (context, state) {
        return SizedBox(
          height: 160,
          child: ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: state.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    controller.text = state[index];
                    cubit.newSort(state[index]);
                  },
                  child: Container(
                    color: index.isEven ? Colors.grey[200] : Colors.grey[300],
                    height: 40.0, // Height for each row
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      state[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  void dismissKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  void onTextChanged() {
    cubit.newSort(controller.text);
    jumpToTop();
  }

  void jumpToTop() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(50);
      }
    });
  }

  Widget textInput() {
    return TextField(
      maxLines: 4,
      controller: controller,
      focusNode: focusNode,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter text',
      ),
    );
  }
}
