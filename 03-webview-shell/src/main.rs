// Native shell: own window with the system webview (WKWebView / WebView2); starts Pharo headless as a sidecar.
use std::{net::TcpStream, path::PathBuf, process::{Command, Stdio}, thread::sleep, time::{Duration, Instant}};
use tao::{event::{Event, WindowEvent}, event_loop::{ControlFlow, EventLoop}, window::WindowBuilder, dpi::LogicalSize};
use wry::WebViewBuilder;

const PORT: u16 = 8765;

fn main() {
    // Inside the .app bundle: Contents/Resources/pharo (VM + image). Otherwise development mode using ~/.stlive.
    let exe = std::env::current_exe().unwrap();
    let bundled = exe.parent().and_then(|p| p.parent()).map(|c| c.join("Resources/pharo")).filter(|p| p.exists());
    let (vm, image, work, script) = if let Some(r) = bundled {
        let work = std::env::temp_dir().join("hello-shell-run");
        std::fs::create_dir_all(&work).unwrap();
        (r.join("pharo-vm/Pharo.app/Contents/MacOS/Pharo"), r.join("app.image"), work, r.join("start.st"))
    } else {
        let home = std::env::var("STLIVE_HOME").map(PathBuf::from)
            .unwrap_or_else(|_| PathBuf::from(std::env::var("HOME").unwrap()).join(".stlive"));
        let pharo = home.join("pharo");
        let work = std::env::current_dir().unwrap().join(".run");
        std::fs::create_dir_all(&work).unwrap();
        for f in ["Pharo.image", "Pharo.changes", "Pharo13.1-64bit-d7c6f76.sources"] { let _ = std::fs::copy(pharo.join(f), work.join(f)); }
        (pharo.join("pharo-vm/Pharo.app/Contents/MacOS/Pharo"), work.join("Pharo.image"), work, std::env::current_dir().unwrap().join("server.st"))
    };
    let mut child = Command::new(vm).current_dir(&work)
        .arg("--headless").arg(&image).arg("st").arg(&script).arg("--no-quit")
        .stdout(std::fs::File::create(work.join("pharo.log")).unwrap()).stderr(Stdio::null()).spawn().expect("Pharo startet nicht");

    let start = Instant::now();
    while TcpStream::connect(("127.0.0.1", PORT)).is_err() {
        if start.elapsed() > Duration::from_secs(60) { let _ = child.kill(); panic!("Server kommt nicht hoch"); }
        sleep(Duration::from_millis(200));
    }

    let event_loop = EventLoop::new();
    let window = WindowBuilder::new().with_title("Hello Native Shell")
        .with_inner_size(LogicalSize::new(520.0, 340.0)).build(&event_loop).unwrap();
    let _webview = WebViewBuilder::new().with_url(format!("http://127.0.0.1:{PORT}")).build(&window).unwrap();

    event_loop.run(move |event, _, flow| {
        *flow = ControlFlow::Wait;
        if let Event::WindowEvent { event: WindowEvent::CloseRequested, .. } = event {
            let _ = child.kill();
            *flow = ControlFlow::Exit;
        }
    });
}
