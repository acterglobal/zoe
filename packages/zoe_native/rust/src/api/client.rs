use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio;
use zoe_client::OverallConnectionStatus;

use extend::ext;
use futures::StreamExt;
use zoe_client::Client;

#[ext]
#[frb]
pub impl Client {
    /// Create a stream of overall connection status for Flutter Rust Bridge
    ///
    /// This is a Flutter Rust Bridge compatible version that uses StreamSink instead of
    /// returning a Stream directly. It spawns a background task that monitors relay
    /// status changes and sends updates to the provided sink.
    fn overall_status_stream_frb(&self, sink: StreamSink<OverallConnectionStatus>) {
        let client = self.clone();

        tokio::spawn(async move {
            let stream = client.overall_status_stream();
            futures::pin_mut!(stream);
            while let Some(status) = stream.next().await {
                // Send update to sink
                if sink.add(status).is_err() {
                    break; // Sink closed, stop the task
                }
            }
        });
    }
}
