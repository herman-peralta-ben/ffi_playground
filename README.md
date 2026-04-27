# FFI Playground
A sample command-line application providing basic argument parsing with an entrypoint in `bin/` to play around with FFI.

## Thread Merge in Flutter 3.39

Historically, the Flutter Engine managed three dedicated threads in addition to the Native Platform Thread. Since recent updates (Flutter 3.x+), the `UI Thread` has been unified with the `Platform Thread`.


### Pre-Merge Architecture:
1. Platform Thread: Host OS main thread (Android/iOS). Handles native events and lifecycle.
2. UI Thread: Dart Isolate execution and Framework logic.
> Note: The `main Isolate` **resided on this UI Thread**, a dedicated execution context managed internally by the Flutter Engine.
3. Raster Thread: Rendering instructions (GPU).
4. IO Thread: Expensive background tasks like image decoding and asset loading.

### Post-Merge (Flutter 3.39+ / Impeller):
With the `UI Thread` merged into the `Platform Thread`, the Android/iOS `main thread` now **handles dual responsibilities**:
1) Processing native system events.
2) **Running the main Isolate’s logic within the same host thread**. 

> 🚨 CRITICAL: While they share the same Thread, **they do not share the same Memory (Heap)**. Data must still be **serialized or converted** when crossing this "bridge" (via Pigeon), or managed via pointers (via FFI), although communication is now synchronous and has zero thread-switching latency.

```mermaid
graph TD
    subgraph PT [Platform Thread - Main / UI]
        Dart[Dart Isolate Main]
        Native[Native Code Kotlin/Swift]
        Dart <--> |Pigeon / FFI<br>🚨 **Shared Thread but separate Heaps**| Native
    end

    subgraph RT [Raster Thread - GPU]
        Engine[Impeller / Skia Engine]
    end

    subgraph IOT [IO Thread]
        Decode[Image Decoding / Disk]
    end

    subgraph WI [Worker Isolates]
        WKR[Heavy CPU Background Tasks e.g. JSON Parsing]
    end

    %% Relaciones
    Dart -->|Layer Tree| Engine
    Dart -->|Request Asset/Image| IOT
    Engine -.->|VSync Signal| PT
    Decode -->|Ready Textures| Engine
    Dart <-->|Send/Receive Port| WI
```

|Feature|Pre-Merge|Post-Merge (Flutter 3.39+)|
|-|-|-|
|Main Isolate Location|Dedicated UI Thread|Shared Platform Thread|
|Communication|Asynchronous (Thread hop)|**Synchronous (Same thread)**|
|Event Loop|Separate loops|Single Unified Event Loop|
|Memory (Heap)|Separate|Still Separate! (Isolated)|
|FFI Performance|Fast (but with thread switch)|Instant (Zero context switch)|

### Unified Event Loop
The Unified Event Loop means that Dart's execution is now interleaved with native OS tasks on the platform's primary message loop. By removing the need for expensive context switching and synchronization between two separate threads, Flutter achieves a more efficient and responsive execution model for both Dart and Native interactions.

### Pigeon: From "Thread Bridge" to "Language Bridge"

In Flutter 3.39+, the role of `Pigeon` has shifted from managing concurrency to **focusing purely on interoperability**.

* Pre-Merge (Asynchronous): Two threads, two "owners of time." Communication was a message sent between offices. You had to await for the other worker to finish.

* Post-Merge (Synchronous): One thread, one "owner of time." Communication is a direct call. The thread simply pauses Dart, executes Native code, and returns with the result.

#### Technical Reality:
What used to be Cross-Thread Communication is now just **Cross-Language Execution**. Since it's the same thread, the "wait" is gone; it is now a sequential function call.

* **Old way**: Send a letter, wait for a reply (await).
* **New way**: Turn around and ask the person next to you (Direct call).

### Notes

> Use FFI for high-performance communication with C/C++/Rust via pointers; use Pigeon for safe, high-level communication with Android/iOS APIs (Kotlin/Swift) via serialization.


## Compiling

### C
* Mac (run from project root)
```bash
clang -dynamiclib -undefined dynamic_lookup native/c/hello.c -o lib/libhello.dylib
```

