const RULESETS = ["orbit_core", "orbit_full"];
const VALID_MODES = ["full", "lite", "off"];

async function applyMode(mode) {
  const safeMode = VALID_MODES.includes(mode) ? mode : "full";
  const enableRulesetIds = safeMode === "full" ? RULESETS : safeMode === "lite" ? ["orbit_core"] : [];
  const disableRulesetIds = RULESETS.filter(id => !enableRulesetIds.includes(id));
  await chrome.declarativeNetRequest.updateEnabledRulesets({ enableRulesetIds, disableRulesetIds });
  await chrome.storage.local.set({ mode: safeMode });
  return safeMode;
}

function validSpotifyUrl(value) {
  try {
    const url = new URL(value);
    return url.protocol === "https:" && (url.hostname === "open.spotify.com" || url.hostname === "spotify.com");
  } catch {
    return false;
  }
}

chrome.runtime.onInstalled.addListener(async () => {
  const settings = await chrome.storage.local.get(["mode", "autoOpen", "destination"]);
  const mode = settings.mode || "full";
  if (settings.autoOpen === undefined) await chrome.storage.local.set({ autoOpen: false });
  if (!settings.destination) await chrome.storage.local.set({ destination: "https://open.spotify.com/" });
  await applyMode(mode);
});

chrome.runtime.onStartup.addListener(async () => {
  const settings = await chrome.storage.local.get(["mode", "autoOpen", "destination"]);
  await applyMode(settings.mode || "full");
  if (settings.autoOpen) {
    const destination = validSpotifyUrl(settings.destination) ? settings.destination : "https://open.spotify.com/";
    await chrome.tabs.create({ url: destination });
  }
});

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message?.type === "orbit-set-mode") {
    applyMode(message.mode)
      .then(mode => sendResponse({ ok: true, mode }))
      .catch(error => sendResponse({ ok: false, error: String(error) }));
    return true;
  }
});
