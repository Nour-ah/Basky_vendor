/// API expects Laravel `date_format:H:i` (e.g. `09:00`), not `H:i:s`.
String toApiTimeHi(String raw) {
  final value = raw.trim();
  final match = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?$').firstMatch(value);
  if (match == null) return value;

  final hour = match.group(1)!.padLeft(2, '0');
  final minute = match.group(2)!;
  return '$hour:$minute';
}
