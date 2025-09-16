use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use tokio;
use zoe_client::{SystemCheck, SystemCheckResults, TestCategory, TestInfo, TestResult};

use futures::StreamExt;
use zoe_client::Client;

// TODO: overwrites here don't work because async but we need it to be in an async
// block due to needing the tokio-spawn.

#[frb]
pub async fn run_system_tests(client: &Client, sink: StreamSink<SystemCheckResults>) {
    let cl = client.clone();
    tokio::spawn(async move {
        let system_check = SystemCheck::with_defaults(cl);
        let runstream = system_check.run_all_stream();
        futures::pin_mut!(runstream);
        while let Some(result) = runstream.next().await {
            if sink.add(result).is_err() {
                break;
            }
        }
    });
}

// SystemCheckResults utility functions
#[frb]
pub fn system_check_results_is_success(results: &SystemCheckResults) -> bool {
    results.is_success()
}

#[frb]
pub fn system_check_results_passed_count(results: &SystemCheckResults) -> u32 {
    results.passed_count() as u32
}

#[frb]
pub fn system_check_results_failed_count(results: &SystemCheckResults) -> u32 {
    results.failed_count() as u32
}

#[frb]
pub fn system_check_results_total_count(results: &SystemCheckResults) -> u32 {
    results.total_count() as u32
}

#[frb]
pub fn system_check_results_total_duration_ms(results: &SystemCheckResults) -> u64 {
    results.total_duration.as_millis() as u64
}

#[frb]
pub fn system_check_results_get_categories(results: &SystemCheckResults) -> Vec<TestCategory> {
    results.results.keys().cloned().collect()
}

#[frb]
pub fn system_check_results_get_tests_for_category(
    results: &SystemCheckResults,
    category: TestCategory,
) -> Vec<TestInfo> {
    results.results.get(&category).cloned().unwrap_or_default()
}

#[frb]
pub fn system_check_results_category_has_failures(
    results: &SystemCheckResults,
    category: TestCategory,
) -> bool {
    results.category_has_failures(category)
}

// TestInfo utility functions
#[frb]
pub fn test_info_get_name(test: &TestInfo) -> String {
    test.name.clone()
}

#[frb]
pub fn test_info_get_details(test: &TestInfo) -> Vec<String> {
    test.details.clone()
}

#[frb]
pub fn test_info_is_passed(test: &TestInfo) -> bool {
    test.result.is_passed()
}

#[frb]
pub fn test_info_is_failed(test: &TestInfo) -> bool {
    test.result.is_failed()
}

#[frb]
pub fn test_info_get_error(test: &TestInfo) -> Option<String> {
    match &test.result {
        TestResult::Failed { error } => Some(error.clone()),
        _ => None,
    }
}

#[frb]
pub fn test_info_duration_ms(test: &TestInfo) -> u64 {
    test.duration.as_millis() as u64
}
