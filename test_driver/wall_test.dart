import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Flutter wall test", () {
    final profile = find.text("Perfil");
    final myProfile = find.byType("ProfilePage");
    final wall = find.byType("HomePage");
    final buttonDrawer = find.byValueKey("drawer");

    late FlutterDriver driver;
    setUpAll(()async{
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if(driver != null){
        driver.close();
      }
    });

    test("Go to Profile", () async {
      await driver.tap(buttonDrawer);
      await driver.tap(profile);
      await driver.waitFor(myProfile);
      assert(myProfile != null);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}