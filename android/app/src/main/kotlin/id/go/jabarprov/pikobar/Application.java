package id.go.jabarprov.pikobar;

import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {

    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        BackgroundFetchPlugin.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry pluginRegistry) {
        GeneratedPluginRegistrant.registerWith(pluginRegistry);
    }
}
