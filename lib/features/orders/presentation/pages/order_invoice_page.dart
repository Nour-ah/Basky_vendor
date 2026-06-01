import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../cubit/order_invoice_cubit.dart';
import '../cubit/order_invoice_state.dart';

class OrderInvoicePage extends StatelessWidget {
  const OrderInvoicePage({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<OrderInvoiceCubit>()..fetchInvoice(orderId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(LocaleKeys.invoice.tr(), style: AppTextStyle.fontBlack16Bold),
          actions: [
            BlocBuilder<OrderInvoiceCubit, OrderInvoiceState>(
              builder: (context, state) {
                if (state is OrderInvoiceLoaded) {
                  return _InvoiceActionsRow(
                    orderId: orderId,
                    state: state,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<OrderInvoiceCubit, OrderInvoiceState>(
          builder: (context, state) {
            if (state is OrderInvoiceLoading) {
              return const LoadingSkeletonList(itemCount: 3);
            }
            if (state is OrderInvoiceError) {
              return StateViewWidget(
                message: state.isNetworkError
                    ? LocaleKeys.noInternetConnection.tr()
                    : state.message,
                icon: state.isNetworkError ? Icons.wifi_off : Icons.error_outline,
                onRetry: () => context.read<OrderInvoiceCubit>().fetchInvoice(orderId),
              );
            }
            if (state is OrderInvoiceLoaded) {
              return _PdfViewerBody(
                orderId: orderId,
                state: state,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _InvoiceActionsRow extends StatelessWidget {
  const _InvoiceActionsRow({
    required this.orderId,
    required this.state,
  });

  final int orderId;
  final OrderInvoiceLoaded state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.download, color: AppColors.black),
          tooltip: LocaleKeys.download.tr(),
          onPressed: () => _downloadPdf(context),
        ),
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.black),
          tooltip: LocaleKeys.share.tr(),
          onPressed: () => _sharePdf(context),
        ),
      ],
    );
  }

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/invoice_$orderId.pdf');
      await file.writeAsBytes(state.invoice.pdfBytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.invoice.tr()} ${LocaleKeys.downloadedSuccessfully.tr()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.error.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/invoice_$orderId.pdf');
      await file.writeAsBytes(state.invoice.pdfBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          title: '${LocaleKeys.invoice.tr()} #$orderId',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${LocaleKeys.error.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _PdfViewerBody extends StatefulWidget {
  const _PdfViewerBody({
    required this.orderId,
    required this.state,
  });

  final int orderId;
  final OrderInvoiceLoaded state;

  @override
  State<_PdfViewerBody> createState() => _PdfViewerBodyState();
}

class _PdfViewerBodyState extends State<_PdfViewerBody> {
  String? _tempFilePath;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _writeTempFile();
  }

  Future<void> _writeTempFile() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/invoice_${widget.orderId}.pdf');
      await file.writeAsBytes(widget.state.invoice.pdfBytes);
      if (mounted) {
        setState(() {
          _tempFilePath = file.path;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return StateViewWidget(
        message: _error!,
        icon: Icons.error_outline,
        onRetry: () {
          setState(() {
            _isLoading = true;
            _error = null;
          });
          _writeTempFile();
        },
      );
    }

    return PDFView(
      filePath: _tempFilePath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      fitPolicy: FitPolicy.WIDTH,
    );
  }
}
