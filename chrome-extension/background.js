const RULESETS = ["orbit_core", "orbit_full"];
const VALID_MODES = ["full", "lite", "off"];
const ALLOWED_WEB_ORIGIN = "https://hightechmit.github.io";

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

function isAllowedExternalSender(sender) {
  try {
    return new URL(sender.url).origin === ALLOWED_WEB_ORIGIN;
  } catch {
    return false;
  }
}

function handleMessage(message, sendResponse) {
  if (message?.type === "orbit-set-mode") {
    applyMode(message.mode)
      .then(mode => sendResponse({ ok: true, mode }))
      .catch(error => sendResponse({ ok: false, error: String(error) }));
    return true;
  }
  if (message?.type === "orbit-get-mode") {
    chrome.storage.local.get("mode")
      .then(({ mode }) => sendResponse({ ok: true, mode: VALID_MODES.includes(mode) ? mode : "full" }))
      .catch(error => sendResponse({ ok: false, error: String(error) }));
    return true;
  }
  return false;
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
  handleMessage(message, sendResponse);
  return true;
});

chrome.runtime.onMessageExternal.addListener((message, sender, sendResponse) => {
  if (!isAllowedExternalSender(sender)) {
    sendResponse({ ok: false, error: "Untrusted website origin." });
    return false;
  }
  return handleMessage(message, sendResponse);
});
