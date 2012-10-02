require 'ruboto/widget'
require 'ruboto/util/toast'

import "android.content.Intent"
import "android.net.Uri"
import android.net.wifi.WifiConfiguration
import android.content.Context

ruboto_import_widgets :Button, :LinearLayout, :TextView

# http://xkcd.com/378/

class NetworkConfiguratorActivity
  def on_create(bundle)
    set_title 'Domo arigato, Mr Ruboto!'

    #intent = getIntent
    #if Intent::ACTION_VIEW intent.getAction
    #  uri = intent.getData
    #  String var = uri.getQueryParameter("var")
    #  String varr = uri.getQueryParameter("varr")
    #end

    self.content_view =
        linear_layout :orientation => :vertical do
          @text_view = text_view :text => "Intent: #{intent.data}", :id => 42, :width => :match_parent,
                                 :gravity => :center, :text_size => 24.0
          button :text => 'Start scan', :width => :match_parent, :id => 43, :on_click_listener => proc { start_scan }
          button :text => 'Trigger URL', :width => :match_parent, :id => 43, :on_click_listener => proc { trigger_url }
          button :text => 'Configure', :width => :match_parent, :id => 43, :on_click_listener => proc { configure }
        end
  rescue
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def onActivityResult(requestCode, resultCode, intent)
    5.times { puts '*' * 80 }
    puts 'onActivityResult'
    5.times { puts '*' * 80 }
    @text_view.text = "Req: #{requestCode} Res: #{resultCode} Intent: #{intent}"
  end

  def on_activity_result(requestCode, resultCode, intent)
    5.times { puts '*' * 80 }
    puts 'on_activity_result'
    5.times { puts '*' * 80 }
    @text_view.text = "Req: #{requestCode} Res: #{resultCode} Intent: #{intent}"
  end

  private

  def start_scan
    intent = Intent.new("com.google.zxing.client.android.SCAN")
    #startActivity(intent)
    startActivityForResult(intent, 0)
  end

  def trigger_url
    intent = Intent.new(Intent::ACTION_VIEW)
    uri = Uri.parse("wifi://eurucamp5/open")
    intent.setData(uri)
    #startActivity(intent)
    #startActivityForResult(intent, 0)
  end

  def configure
    hotSpotSsid = 'eurucamp_5'
    hotSpotBssid = 'bc:05:43:26:cb:b8' # ???
    puts "in RSSI Changed Acion SSID: " + hotSpotSsid + " BSSID: " + hotSpotBssid
                                #StringBuffer sBuf = new StringBuffer("\"");
                                #sBuf.append(hotSpotSsid+"\"");
                                #hotSpotSsid = sBuf.toString();

    wifiConfiguration = WifiConfiguration.new
    wifiConfiguration.SSID = "\"#{hotSpotSsid}\""
    wifiConfiguration.allowedKeyManagement.set(WifiConfiguration::KeyMgmt::NONE)
    wifiConfiguration.BSSID = hotSpotBssid
    # wifiConfiguration.hiddenSSID = false
    wifiConfiguration.priority = 1
    wifiConfiguration.status = WifiConfiguration::Status::ENABLED

    wifiManager = getSystemService(Context::WIFI_SERVICE)
    inetId = wifiManager.addNetwork(wifiConfiguration)
    configs = wifiManager.getConfiguredNetworks
    puts "After adding config :"+ configs.to_s
    if inetId < 0
      puts "Unable to add network configuration for SSID: #{hotSpotSsid}"
    else
      message = "\t Successfully added to configured Networks"
      puts message
      wifiManager.enableNetwork(inetId,true)
      finish
    end
  end

end
