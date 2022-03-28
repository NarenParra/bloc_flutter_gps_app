import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc()
      : super(const GpsState(
            // se inicializa el estado
            isGpsEnabled: false,
            isGpsPermissionGranted: false)) {
    //hacer algo cuando resiva un evento, En esta parte va la logica
    //en este caso solo       emite un nuevo estado
    on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsEnabled: event.isGpsEnabled,
        isGpsPermissionGranted: event.isGpsPermissionGranted)));

// esto se llama al iniciar la app
    _init();
  }

  //
  Future<void> _init() async {
    final isEnabled = await _checkGpsStatus();
    print('isEnabled $isEnabled');

    //dispara evento del bloque

    add(GpsAndPermissionEvent(
        isGpsEnabled: isEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted));
  }

  // logica para obtener la info de geolocator
  Future<bool> _checkGpsStatus() async {
    //consulta inicial para conocer estado del gps
    final isEnable = await Geolocator.isLocationServiceEnabled();

    //saber si apagan el gps
    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnable = (event.index == 1) ? true : false;
      print('service status $isEnable');
      // logica para estar pendiente de los cambios, disparar eventos
      add(GpsAndPermissionEvent(
          isGpsEnabled: isEnable,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
    });
    return isEnable;
  }

  //es buena practica cerrar el listener

  @override
  Future<void> close() {
    // limpiar el listener
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
