
import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';

Future<String> scanBarcode({required BuildContext context}) async {
    MobileScannerController controller = MobileScannerController();
    String? scannedValue;
    bool isScanned = false;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) {
        return AiBarcodeScanner(
          cutOutHeight: 150.0,
          cutOutWidth: 320.0,
          cutOutSize: 0.0,
          borderRadius: 8,
          borderWidth: 8,
          controller: controller,
          onDetect: (BarcodeCapture capture) async {
            scannedValue = capture.barcodes.first.rawValue;
            if (scannedValue != null && scannedValue!.isNotEmpty && !isScanned) {
              log("${capture.barcodes.first.rawValue} scanned value");
              isScanned = true;
              Navigator.pop(ctx);
              await controller.dispose();
            }
          },
          hideGalleryButton: true,
          bottomSheetBuilder: (ctx, controller) {
            return const SizedBox();
          },
        );
      }),
    );
    return scannedValue!;
  }