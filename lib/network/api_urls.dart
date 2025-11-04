import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Dev-friendly base URL selection:
/// - On Android emulator, use 10.0.2.2 to reach host machine.
/// - On other platforms default to localhost.
final String base_url = (() {
	if (kIsWeb) return 'http://localhost:4000';
	if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:4000';
	return 'http://localhost:4000';
})();