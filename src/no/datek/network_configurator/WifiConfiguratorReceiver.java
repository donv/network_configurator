package no.datek.network_configurator;

import org.ruboto.JRubyAdapter;

public class WifiConfiguratorReceiver extends org.ruboto.RubotoBroadcastReceiver {
    private boolean scriptLoaded = false;

    public WifiConfiguratorReceiver() {
        super("wifi_configurator_receiver.rb");
        if (JRubyAdapter.isInitialized()) {
            scriptLoaded = true;
        }
    }

    public void onReceive(android.content.Context context, android.content.Intent intent) {
        if (!scriptLoaded) {
            if (JRubyAdapter.setUpJRuby(context)) {
                loadScript();
                scriptLoaded = true;
            } else {
                // FIXME(uwe): What to do if the Ruboto Core platform is missing?
            }
        }
        super.onReceive(context, intent);
    }

}
