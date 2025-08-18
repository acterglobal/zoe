pub mod api;
mod frb_generated;

// Re-export all the types that FRB needs at the crate root
// This ensures they're available through `use crate::*;` in the generated code
pub use zoe_client::{FileRef, SigningKey, VerifyingKey};
pub use std::net::SocketAddr;
pub use std::path::PathBuf;
// Note: Don't re-export Path as it's !Sized and FRB can't handle it
// Use PathBuf instead in function signatures
