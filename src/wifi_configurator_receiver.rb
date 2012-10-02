import android.util.Log

class WifiConfiguratorReceiver
  # will get called whenever the BroadcastReceiver receives an intent (whenever onReceive is called)
  def on_receive(context, intent)
    Log.v "WifiConfiguratorReceiver", 'Broadcast received!'
    Log.v "WifiConfiguratorReceiver", intent.getExtras.to_s
    context.run_on_ui_thread do
      begin
        $activity.title = 'Broadcast received!'
      rescue Exception
        Log.e "Exception setting title: #{$!.message}\n#{$!.backtrace.join("\n")}"
      end
    end
    Log.v "WifiConfiguratorReceiver", 'Broadcast processed OK!'
  rescue Exception
    Log.e "Exception processing broadcast: #{$!.message}\n#{$!.backtrace.join("\n")}"
  end
end
