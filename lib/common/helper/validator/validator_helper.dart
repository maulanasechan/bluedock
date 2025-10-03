typedef StringValidator = String? Function(String?);

class AppValidators {
  static final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _pwRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');
  static final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  static final RegExp _nikRegex = RegExp(r'^[0-9]+$');
  static final RegExp _digitsOnly = RegExp(r'^\d+$');
  static final RegExp _numberRange = RegExp(r'^\d+(-\d+)?$');
  static final RegExp _numberDecimal = RegExp(r'^\d+(\.\d+)?$');

  static StringValidator required({String? field}) {
    return (v) =>
        (v == null || v.trim().isEmpty) ? '$field is required.' : null;
  }

  static StringValidator numberOrRange({
    String requiredMessage = 'This field is required.',
    String invalidMessage = 'Only numbers or ranges like 354-882 are allowed.',
    bool ensureStartLEEnd = true,
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      if (!_numberRange.hasMatch(s)) return invalidMessage;

      final parts = s.split('-');
      if (parts.length == 2) {
        final start = int.parse(parts[0]);
        final end = int.parse(parts[1]);
        if (ensureStartLEEnd && start > end) {
          return 'Start must be <= end.';
        }
      }
      return null;
    };
  }

  static StringValidator numberOrDecimal({
    String requiredMessage = 'This field is required.',
    String invalidMessage = 'Enter a valid integer or decimal.',
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      return _numberDecimal.hasMatch(s) ? null : invalidMessage;
    };
  }

  static StringValidator number({
    String requiredMessage = 'This field is required.',
    String invalidMessage = 'Only numbers are allowed.',
    int minLength = 1,
    int? maxLength,
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      if (!_digitsOnly.hasMatch(s)) return invalidMessage;
      if (s.length < minLength) {
        return 'Must be at least $minLength digit${minLength > 1 ? 's' : ''}.';
      }
      if (maxLength != null && s.length > maxLength) {
        return 'Must be at most $maxLength digit${maxLength > 1 ? 's' : ''}.';
      }
      return null;
    };
  }

  static StringValidator email({
    String requiredMessage = 'Email is required.',
    String invalidMessage = 'Enter a valid email.',
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      return _emailRegex.hasMatch(s) ? null : invalidMessage;
    };
  }

  static StringValidator fullName({
    String requiredMessage = 'Fullname is required.',
    String lengthMessage = 'Fullname must be at least 4 characters long.',
    String invalidMessage = 'Fullname must only contain letters and spaces.',
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      if (s.length < 4) return lengthMessage;
      return _nameRegex.hasMatch(s) ? null : invalidMessage;
    };
  }

  static StringValidator address({
    String requiredMessage = 'Address is required.',
    String lengthMessage = 'Address must be at least 10 characters long.',
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      if (s.length < 10) return lengthMessage;
      return null;
    };
  }

  static StringValidator nik({
    String requiredMessage = 'NIK is required.',
    String lengthMessage = 'NIK must be exactly 16 digits.',
    String invalidMessage = 'NIK must only contain numbers.',
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      if (!_nikRegex.hasMatch(s)) return invalidMessage;
      if (s.length != 16) return lengthMessage;
      return null;
    };
  }

  static StringValidator nip({
    String requiredMessage = 'NIP is required.',
    String lengthMessage = 'NIP must be exactly 16 digits.',
    String invalidMessage = 'NIP must only contain numbers.',
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      if (!_nikRegex.hasMatch(s)) return invalidMessage;
      if (s.length != 6) return lengthMessage;
      return null;
    };
  }

  static StringValidator password({
    String requiredMessage = 'Password is required.',
    String lengthMessage = 'Must be at least 8 characters long',
    String weakMessage =
        'Must be at least 8 characters long and include both letters and numbers.',
  }) {
    return (v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return requiredMessage;
      if (s.length < 8) return lengthMessage;
      return _pwRegex.hasMatch(s) ? null : weakMessage;
    };
  }

  static StringValidator compose(List<StringValidator> validators) {
    return (v) {
      for (final fn in validators) {
        final res = fn(v);
        if (res != null) return res;
      }
      return null;
    };
  }
}
