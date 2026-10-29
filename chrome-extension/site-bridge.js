(() => {
  const PAGE_ORIGIN = "https://hightechmit.github.io";
  window.addEventListener("message", event => {
    if (event.source !== window || event.origin !== PAGE_ORIGIN) return;
    const data = event.data;
    if (!data || data.source !== "orbit-music-page" || data.direction !== "request" || typeof data.id !== "string") return;
    chrome.runtime.sendMessage(data.message, response => {
      const runtimeError = chrome.runtime.lastError;
      window.postMessage({
        source: "orbit-music-extension",
        direction: "response",
        id: data.id,
        response: runtimeError
          ? { ok: false, error: runtimeError.message }
          : response || { ok: false, error: "Orbit extension returned no response." }
      }, PAGE_ORIGIN);
    });
  });
})();
