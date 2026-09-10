{ ... }:

{
  programs.firefox = {
    enable = true;
    policies = {
      AppAutoUpdate = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundAppUpdate = false;
      DisableAccounts = true;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePasswordReveal = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      HttpsOnlyMode = "disallowed";
      NewTabPage = false;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      PromptForDownloadLocation = false;
      SearchSuggestEnabled = true;
      ShowHomeButton = false;
      SkipTermsOfUse = true;
      TranslateEnabled = false;
      VisualSearchEnabled = false;

      EnableTrackingProtection = {
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        Locked = true;
      };

      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = false;
        Locked = true;
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
        Locked = true;
      };

      Homepage = {
        StartPage = "none";
        Locked = true;
      };

      DNSOverHTTPS = {
        Enabled = false;
        Locked = true;
      };

      SanitizeOnShutdown = {
        Cache = true;
        FormData = true;
        History = true;
        Locked = true;
      };

      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnBoarding = false;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };

      WebsiteFilter = {
        Block = [
          "*://*.twitch.tv/*"
          "*://*.netflix.com/*"
          "*://*.chatgpt.com/*"
          "*://*.quora.com/*"
          "*://*.discord.com/*"
          "*://*.facebook.com/*"
          "*://*.messenger.com/*"
          "*://*.instagram.com/*"
          "*://*.threads.com/*"
          "*://*.x.com/*"
          "*://*.tiktok.com/*"
          "*://*.snapchat.com/*"
        ];
      };

      # TODO: Set preferences
      # Preferences = {};
      # TODO: Add useful bookmarks
      # Bookmarks = [];
      # TODO: Add default extensions
      # Extensions = {};
      # ExtensionSettings = {};
      # TODO: Set Search engines
      # SearchEngines = {};
    };
  };
}
