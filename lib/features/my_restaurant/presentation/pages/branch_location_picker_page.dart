import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../models/branch_location_result.dart';

class BranchLocationPickerPage extends StatefulWidget {
  const BranchLocationPickerPage({
    super.key,
    this.initialAddress,
    this.initialLatitude,
    this.initialLongitude,
  });

  final String? initialAddress;
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<BranchLocationPickerPage> createState() =>
      _BranchLocationPickerPageState();
}

class _BranchLocationPickerPageState extends State<BranchLocationPickerPage> {
  static const _defaultTarget = LatLng(30.0444, 31.2357);

  final _searchController = TextEditingController();
  final _mapController = Completer<GoogleMapController>();
  final _geocoder = Geocoding();

  late LatLng _selected;
  String _address = '';
  bool _resolvingAddress = false;
  bool _searching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final lat = widget.initialLatitude;
    final lng = widget.initialLongitude;
    if (lat != null && lng != null) {
      _selected = LatLng(lat, lng);
    } else {
      _selected = _defaultTarget;
    }
    _address = widget.initialAddress?.trim() ?? '';
    if (_address.isEmpty) {
      unawaited(_resolveAddress(_selected));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _resolveAddress(LatLng point) async {
    setState(() => _resolvingAddress = true);
    try {
      final places = await _geocoder.placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (!mounted) return;
      if (places.isNotEmpty) {
        final p = places.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country,
        ].whereType<String>().where((e) => e.trim().isNotEmpty).toList();
        setState(() {
          _address = parts.isEmpty
              ? '${point.latitude.toStringAsFixed(5)}, '
                  '${point.longitude.toStringAsFixed(5)}'
              : parts.join(', ');
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _address =
            '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
      });
    } finally {
      if (mounted) setState(() => _resolvingAddress = false);
    }
  }

  Future<void> _moveCamera(LatLng target) async {
    final controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
  }

  Future<void> _searchPlace(String query) async {
    final q = query.trim();
    if (q.length < 3) return;
    setState(() => _searching = true);
    try {
      final locations = await _geocoder.locationFromAddress(q);
      if (!mounted || locations.isEmpty) return;
      final first = locations.first;
      final target = LatLng(first.latitude, first.longitude);
      setState(() => _selected = target);
      await _moveCamera(target);
      await _resolveAddress(target);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.locationSearchFailed.tr()),
          backgroundColor: AppColors.promoRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _goToMyLocation() async {
    final permission = await Geolocator.checkPermission();
    var status = permission;
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.locationPermissionDenied.tr()),
          backgroundColor: AppColors.promoRed,
        ),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    final target = LatLng(position.latitude, position.longitude);
    setState(() => _selected = target);
    await _moveCamera(target);
    await _resolveAddress(target);
  }

  void _onCameraIdle() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(_resolveAddress(_selected));
    });
  }

  void _confirm() {
    final address = _address.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.addressRequired.tr()),
          backgroundColor: AppColors.promoRed,
        ),
      );
      return;
    }
    Navigator.pop(
      context,
      BranchLocationResult(
        address: address,
        latitude: _selected.latitude,
        longitude: _selected.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
        title: Text(
          LocaleKeys.selectLocation.tr(),
          style: AppTextStyle.fontBlack16Bold,
        ),
        actions: [
          IconButton(
            onPressed: _goToMyLocation,
            icon: const Icon(Icons.my_location, color: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _searchPlace,
              decoration: InputDecoration(
                hintText: LocaleKeys.searchPlace.tr(),
                hintStyle: AppTextStyle.fontGrey12Regular,
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => _searchPlace(_searchController.text),
                      ),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selected,
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    if (!_mapController.isCompleted) {
                      _mapController.complete(controller);
                    }
                  },
                  onCameraMove: (position) {
                    _selected = position.target;
                  },
                  onCameraIdle: _onCameraIdle,
                ),
                const IgnorePointer(
                  child: Icon(
                    Icons.location_on,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_resolvingAddress)
                  const LinearProgressIndicator(minHeight: 2)
                else
                  Text(
                    _address.isEmpty
                        ? LocaleKeys.moveMapToSelect.tr()
                        : _address,
                    style: AppTextStyle.fontGrey14Regular,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: _confirm,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.confirmLocation.tr(),
                      style: AppTextStyle.fontWhite16Bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
