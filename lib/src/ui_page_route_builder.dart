// Import the Flutter Material package for UI components.
import 'package:flutter/material.dart';
// Import UI extensions for Flutter, providing additional utility functions and widgets.
import 'package:ui_extensions_flutter/ui_extensions_flutter.dart';
// Import UI positioned overlay package for Flutter, allowing for overlay widgets to be positioned on screen.
import 'package:ui_positioned_overlay_flutter/ui_positioned_overlay_flutter.dart';

// Import a custom UI text field cache for Flutter, likely used for caching text field entries.
import '../ui_textfield_cache_flutter.dart';

/// Creates a page route builder that returns a transparent overlay positioned on the screen.
///
/// This function builds a route for displaying a UI overlay, which is positioned
/// at a specified distance from the top of the screen. The overlay contains a cached
/// text field, allowing for user input to be cached and retrieved.
///
/// Returns:
///   A [PageRouteBuilder] widget that creates route animations for the overlay.
///
// Ignore naming convention warnings for non-constant identifier names.
// ignore: non_constant_identifier_names
PageRouteBuilder<String?> UIPageRouteBuilder({
  Color darkColor = Colors.black87,
  Color lightColor = Colors.white70,
}) =>
    PageRouteBuilder<String?>(
      // Set the page route to be transparent.
      opaque: false,
      // Define the page builder function, providing context and animation controllers.
      pageBuilder: (context, _, __) => UIPositionedOverlayWidget(
        // Set the horizontal offset of the positioned overlay (from the left).
        dx: 0.0,
        // Set the vertical offset of the positioned overlay (from the top).
        dy: 75.0,
        // The builder for the overlay content, taking a context and a result callback.
        builder: (context, result) => SizedBox(
          // Set the width of the overlay to match the width of the context (screen width).
          width: context.width,
          // Wrap the content in a Card widget for a standard material design card.
          child: Card(
            //color: Colors.black87,
            // The child of the Card is a UICachedTextField, which caches the user input.
            // The callback function is used to handle the text input result.
            child: UICachedTextField(callback: (String? text) => result(text))
                .paddingAll(4.0),
          ),
        ),
      ),
    );
