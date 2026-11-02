import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/local_store.dart';
import '../../../../l10n/app_localizations.dart';

class ProductImage extends StatefulWidget {
  const ProductImage({super.key, required this.url});
  final String url;
  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  late Future<Uint8List?> _image;
  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
  @override
  void initState() {
    super.initState();
    _image = _load();
  }

  @override
  void didUpdateWidget(covariant ProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) _image = _load();
  }

  Future<Uint8List?> _load() async {
    final store = context.read<LocalStore>();
    final url = widget.url;
    if (url.isEmpty) return null;
    try {
      final bytes = await store.readImage(url);
      if (bytes != null) return bytes;
    } catch (_) {
      /* A cache failure must not hide the remote image. */
    }
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(response.data!);
      try {
        await store.saveImage(url, bytes);
      } catch (_) {
        /* Still show the image. */
      }
      return bytes;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List?>(
    future: _image,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }
      if (snapshot.data == null) {
        return IconButton(
          tooltip: AppLocalizations.of(context)!.retryImage,
          onPressed: () => setState(() => _image = _load()),
          icon: const Icon(Icons.image_not_supported_outlined),
        );
      }
      return Image.memory(
        snapshot.data!,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => IconButton(
          tooltip: AppLocalizations.of(context)!.retryImage,
          onPressed: () async {
            // A corrupt cache entry is replaced by the next network fetch.
            try {
              await (await context.read<LocalStore>().database).delete(
                'images',
                where: 'url = ?',
                whereArgs: [widget.url],
              );
            } catch (_) {}
            if (mounted) setState(() => _image = _load());
          },
          icon: const Icon(Icons.broken_image_outlined),
        ),
      );
    },
  );
}
