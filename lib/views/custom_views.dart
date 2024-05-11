
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expenses_manager/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../extension/extension.dart';

extension CustomViews on Widget {
  static Widget getMaterialButton(BuildContext context, String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: color))),
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(EdgeInsets.all(16)),
        ),
        child: Text(label));
  }

  static Widget buildProgressView(List<Widget> views, Stream<bool> progress) {
    views.add(StreamBuilder<bool>(
        stream: progress,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.requireData
              ? InkWell(
            child: Container(
              color: Colors.black38,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
              : SizedBox();
        }));
    return Stack(
      children: views,
    );
  }

  static Widget buildLoadingView(Widget view, bool progress) {
    return Stack(
      children: [
        view,
        if (progress)
          InkWell(
            child: Container(
              color: Colors.black26,
              child: Center(
                child: Lottie.asset("assets/lottie/loading.json", repeat: true),
              ),
            ),
          )
      ],
    );
  }

  static Widget buildNetworkImage(String? url, {double? height, double? width, BoxFit? fit}) {
    return CachedNetworkImage(
      imageUrl: "PrefUtils.getBaseImageUrl()" + (url ?? ""),
      placeholder: (context, url) => Center(
          child: Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.grey,
              ))),
      errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
              color: Colors.white,
              child: Center(
                  child: Image.asset(
                    "assets/images/logo_splash.png",
                  )))),
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
    );
  }

  static Widget buildTextField(String title, String hint,
      {TextEditingController? controller,
        TextInputType? inputType,
        IconData? prefixIcon,
        Function? onChanged,
        MaskTextInputFormatter? maskTextInputFormatter,
        bool obscureText = false,
        bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: BLACK),
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          keyboardType: inputType,
          maxLines: 1,
          enabled: enabled,
          inputFormatters: maskTextInputFormatter != null ? [maskTextInputFormatter] : null,
          onChanged: (text) {
            if (onChanged != null) {
              onChanged(text);
            }
          },
          decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Icon(
                prefixIcon,
                color: Colors.grey.shade500,
              )
                  : null,
              enabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(color: HexColor.fromHex("#EBF0FF"), width: 1.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey),
              hintText: hint,
              fillColor: Colors.white70),
        )
      ],
    );
  }

  static Widget buildSearchTextField(String hint,
      {TextEditingController? controller,
        TextInputType? inputType,
        IconData? prefixIcon,
        Function? onChanged,
        MaskTextInputFormatter? maskTextInputFormatter,
        bool obscureText = false,
        bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox.fromSize(
          size: Size.fromHeight(56),
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.next,
            keyboardType: inputType,
            maxLines: 1,
            enabled: enabled,
            inputFormatters: maskTextInputFormatter != null ? [maskTextInputFormatter] : null,
            onChanged: (text) {
              if (onChanged != null) {
                onChanged(text);
              }
            },
            decoration: InputDecoration(
                prefixIcon: prefixIcon != null
                    ? Icon(
                  prefixIcon,
                  color: Colors.grey.shade500,
                )
                    : null,
                enabledBorder: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
                hintText: hint,
                fillColor: Colors.white70),
          ),
        )
      ],
    );
  }

  static Widget buildMiniTextField(String title, String hint,
      {TextEditingController? controller,
        TextInputType? inputType,
        IconData? prefixIcon,
        Function? onChanged,
        MaskTextInputFormatter? maskTextInputFormatter,
        bool obscureText = false,
        bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: BLACK),
        ),
        SizedBox(height: 4),
        SizedBox.fromSize(
          size: Size.fromHeight(56),
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.next,
            keyboardType: inputType,
            maxLines: 1,
            enabled: enabled,
            inputFormatters: maskTextInputFormatter != null ? [maskTextInputFormatter] : null,
            onChanged: (text) {
              if (onChanged != null) {
                onChanged(text);
              }
            },
            style: TextStyle(color: enabled ? Colors.black : Colors.grey),
            decoration: InputDecoration(
                prefixIcon: prefixIcon != null
                    ? Icon(
                  prefixIcon,
                  color: COLOR_PRIMARY,
                )
                    : null,
                enabledBorder: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
                hintText: hint,
                fillColor: Colors.white70),
          ),
        )
      ],
    );
  }

  static Widget buildMoreTextField(String title, String hint,
      {TextEditingController? controller, bool enabled = true, IconData? prefixIcon, Function? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: BLACK),
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          enabled: enabled,
          onChanged: (text) {
            if (onChanged != null) {
              onChanged(text);
            }
          },
          decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Icon(
                prefixIcon,
                color: Colors.grey.shade500,
              )
                  : null,
              enabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(color: HexColor.fromHex("#EBF0FF"), width: 1.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey),
              hintText: hint,
              fillColor: Colors.white70),
        )
      ],
    );
  }
}
