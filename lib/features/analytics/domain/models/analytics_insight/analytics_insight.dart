/// The insight generator's output (design_spendlens.md §6/§10, spec §53) —
/// an ARB **key + params pair**, never a rendered string. This is what keeps
/// the generator locale-independent and unit-testable without a
/// `BuildContext`: the UI layer resolves [key] through `AppLocalizations`
/// and passes [params] positionally, in the order each ARB placeholder
/// expects.
///
/// The six keys this generator may emit are the ones design_spendlens.md
/// §4.4 names as already-parameterized: `ins1`, `ins2`, `ins3` (current
/// month) and `insA1`, `insA2`, `insA3` (previous/archived month).
enum EAnalyticsInsightKey { ins1, ins2, ins3, insA1, insA2, insA3 }

class AnalyticsInsight {
  final EAnalyticsInsightKey key;

  /// Positional params, in the exact order the ARB template for [key]
  /// expects them. The UI layer is the only place that knows how to spread
  /// these into the generated `AppLocalizations` method call.
  final List<Object> params;

  const AnalyticsInsight({required this.key, required this.params});

  @override
  bool operator ==(Object other) =>
      other is AnalyticsInsight &&
      other.key == key &&
      other.params.length == params.length &&
      _paramsEqual(other.params);

  bool _paramsEqual(List<Object> otherParams) {
    for (var i = 0; i < params.length; i++) {
      if (params[i] != otherParams[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(key, Object.hashAll(params));

  @override
  String toString() => 'AnalyticsInsight($key, $params)';
}
