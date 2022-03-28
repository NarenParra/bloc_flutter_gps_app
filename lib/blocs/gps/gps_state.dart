part of 'gps_bloc.dart';

class GpsState extends Equatable {
  //constante del estado inicial
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;

  const GpsState(
      {required this.isGpsEnabled, required this.isGpsPermissionGranted});

  //este metodo copia el estado anterior del bloc
  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
  }) =>
      GpsState(
          isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
          isGpsPermissionGranted:
              isGpsPermissionGranted ?? this.isGpsPermissionGranted);

  @override
  List<Object> get props => [isGpsEnabled, isGpsPermissionGranted];

  //para imprimir el estado --- se debe borrar
  @override
  String toString() =>
      '{isGpsEnabled: $isGpsEnabled,  isGpsPermissionGranted: $isGpsPermissionGranted}';
}
