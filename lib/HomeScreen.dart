import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  static final LatLng companyLatLng = LatLng(36.833687, 127.179960); // 지도 초기 위치
  static final Marker marker = Marker(
      markerId: MarkerId('company'),
      position: companyLatLng,
      );

  static final Circle circle = Circle(
      circleId: CircleId('choolCheckCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == '위치 권한이 허가 되었습니다.') {
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: companyLatLng,
                      zoom: 16,
                    ),
                    markers: Set.from([marker]),
                    circles: Set.from([circle]),
                    myLocationEnabled: true,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timelapse_outlined, color: Colors.blue, size: 50.0),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                          onPressed: () async{
                            final curPosition = await Geolocator.getCurrentPosition(); //현재 위치

                            final distance = Geolocator.distanceBetween(
                              curPosition.latitude, //현재 위치 위도
                              curPosition.longitude, //현재위치 경도
                              companyLatLng.latitude, //회사위치 경도
                              companyLatLng.longitude,
                            );
                            bool canCheck =
                                distance < 100; //100미터 이내에 있으면 출근 가능
                            showDialog(
                                context: context,
                                builder: (_){
                                  return AlertDialog(
                                    title: Text('출근하기'),
                                    //출근 가능 여부에 따라 다른 메시지 제공
                                    content:  Text(
                                        canCheck? '출근을 하시겠습니까?':'출근할 수 없는 위치입니다.',
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child:Text('취소'),
                                          ),
                                          if(canCheck) //출근 가능한 상태일 때만 출근하기 버튼 제공
                                              TextButton(onPressed: (){
                                                  Navigator.of(context).pop(true);
                                              },
                                                child: Text('출근하기'),
                                              ),
                                    ],
                                  );
                                },
                            );
                          },
                          child: Text('출근!')
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: Text(snapshot.data.toString()));
        },
      ),
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();
      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    return '위치 권한이 허가 되었습니다.';
  }

  AppBar renderAppBar() {
    return AppBar(
      title: Text(
        '오늘도 출근',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
