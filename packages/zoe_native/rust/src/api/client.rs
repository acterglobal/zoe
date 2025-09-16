use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio;
use zoe_client::OverallConnectionStatus;

use futures::StreamExt;
use zoe_client::Client;

// TODO: overwrites here don't work because async but we need it to be in an async
// block due to needing the tokio-spawn.

#[frb]
pub async fn overall_status_stream(client: &Client, sink: StreamSink<OverallConnectionStatus>) {
    let client = client.clone();

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
