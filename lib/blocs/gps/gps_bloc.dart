import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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
//llamado por separado de las features
    // final isEnabled = await _checkGpsStatus();
    // final isGranted = await _isPermissionGranted();
//    print('isEnabled $isEnabled, isGranted: $isGranted');

    //disparar diferentes features en paralelo
    //retorna un arreglo de booleanos en este caso
    final gpsInitalStatus =
        await Future.wait([_checkGpsStatus(), _isPermissionGranted()]);

    //dispara evento del bloque

    add(GpsAndPermissionEvent(
        isGpsEnabled: gpsInitalStatus[0],
        isGpsPermissionGranted: gpsInitalStatus[1]));
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

  //no mostrar el modal de privilegios si ya se otorgaron
  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

//pedir el acceso al gps, mediante la panatalla de privilegios en el dispositivo
  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    // para pedir permisos de utilizar la localizacion
    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true));
        openAppSettings();
    }
  }

  //es buena practica cerrar el listener
  @override
  Future<void> close() {
    // limpiar el listener
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
