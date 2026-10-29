(() => {
  const STYLE_ID = "orbit-music-cosmetic-style";
  let mode = "full";
  let cosmeticEnabled = true;
  const style = document.createElement("style");
  style.id = STYLE_ID;
  style.textContent = ".orbit-music-hidden-ad{display:none!important}";
  (document.documentElement || document).appendChild(style);

  function looksLikeLabeledAd(element) {
    const testId = (element.getAttribute("data-testid") || "").trim();
    const aria = (element.getAttribute("aria-label") || "").trim();
    const title = (element.getAttribute("title") || "").trim();
    const marker = /(^|[-_ ])(ad|ads|ad-slot|advert|advertisement|sponsored|promoted)([-_ ]|$)/i;
    return marker.test(testId) || /^(advertisement|sponsored content|promoted ad)$/i.test(aria) || /^(advertisement|sponsored content)$/i.test(title);
  }

  function scan() {
    if (mode === "off" || !cosmeticEnabled) {
      document.querySelectorAll(".orbit-music-hidden-ad").forEach(element => element.classList.remove("orbit-music-hidden-ad"));
      return;
    }
    document.querySelectorAll("[data-testid], [aria-label], [title]").forEach(element => {
      if (!looksLikeLabeledAd(element)) return;
      const container = element.closest('[data-testid="ad-slot"], article, section') || element;
      if (container !== document.body && container !== document.documentElement) container.classList.add("orbit-music-hidden-ad");
    });
  }

  chrome.storage.local.get(["mode", "cosmetic"]).then(settings => {
    mode = settings.mode || "full";
    cosmeticEnabled = settings.cosmetic !== false;
    scan();
  });
  chrome.storage.onChanged.addListener((changes, area) => {
    if (area !== "local") return;
    if (changes.mode) mode = changes.mode.newValue || "full";
    if (changes.cosmetic) cosmeticEnabled = changes.cosmetic.newValue !== false;
    scan();
  });
  const observer = new MutationObserver(() => scan());
  observer.observe(document.documentElement, { childList: true, subtree: true, attributes: true, attributeFilter: ["data-testid", "aria-label", "title"] });
})();