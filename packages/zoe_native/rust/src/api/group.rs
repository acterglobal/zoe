use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio;

use futures::StreamExt;
use zoe_state_machine::group::{GroupDataUpdate, GroupManager};

// TODO: overwrites here don't work because async but we need it to be in an async
// block due to needing the tokio-spawn.

#[frb]
pub async fn group_updates_stream(manager: &GroupManager, sink: StreamSink<GroupDataUpdate>) {
    let manager = manager.clone();

    tokio::spawn(async move {
        let stream = manager.subscribe_to_updates();
        futures::pin_mut!(stream);
        while let Some(update) = stream.next().await {
            // Send update to sink
            if sink.add(update).is_err() {
                break; // Sink closed, stop the task
            }
        }
    });
}
