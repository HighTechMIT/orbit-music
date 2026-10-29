const $ = id => document.getElementById(id);
const DEFAULT_DESTINATION = "https://open.spotify.com/";

function validSpotifyUrl(value) {
  try {
    const url = new URL(value);
    return url.protocol === "https:" && (url.hostname === "open.spotify.com" || url.hostname === "spotify.com");
  } catch {
    return false;
  }
}

async function openSpotify(destination) {
  const url = validSpotifyUrl(destination) ? destination : DEFAULT_DESTINATION;
  await chrome.tabs.create({ url });
  window.close();
}

async function setMode(mode) {
  $("status").textContent = "Updating protection…";
  const result = await chrome.runtime.sendMessage({ type: "orbit-set-mode", mode });
  if (!result?.ok) {
    $("status").textContent = "Could not update protection. Try reloading the extension.";
    return;
  }
  document.querySelectorAll("[data-mode]").forEach(button => {
    button.setAttribute("aria-pressed", String(button.dataset.mode === result.mode));
  });
  $("status").textContent = result.mode === "full" ? "Full protection enabled." : result.mode === "lite" ? "Lite protection enabled." : "Network protection is off.";
}

async function init() {
  const settings = await chrome.storage.local.get(["mode", "autoOpen", "destination", "cosmetic"]);
  const mode = settings.mode || "full";
  document.querySelectorAll("[data-mode]").forEach(button => {
    button.setAttribute("aria-pressed", String(button.dataset.mode === mode));
    button.addEventListener("click", () => setMode(button.dataset.mode));
  });
  $("autoOpen").checked = Boolean(settings.autoOpen);
  $("cosmetic").checked = settings.cosmetic !== false;
  $("openSpotify").addEventListener("click", () => openSpotify(DEFAULT_DESTINATION));
  $("openSaved").addEventListener("click", () => openSpotify(settings.destination || DEFAULT_DESTINATION));
  $("liked").addEventListener("click", () => openSpotify("https://open.spotify.com/collection/tracks"));
  $("search").addEventListener("click", () => openSpotify("https://open.spotify.com/search"));
  $("autoOpen").addEventListener("change", () => chrome.storage.local.set({ autoOpen: $("autoOpen").checked }));
  $("cosmetic").addEventListener("change", () => chrome.storage.local.set({ cosmetic: $("cosmetic").checked }));
  $("status").textContent = mode === "full" ? "Full protection enabled." : mode === "lite" ? "Lite protection enabled." : "Network protection is off.";
}
init().catch(() => { $("status").textContent = "Could not load settings. Reload the extension."; });
